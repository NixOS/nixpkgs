{ lib
, stdenv
, runCommand
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, callPackage

, build
, numpy
, pillow
, pytest
, setuptools-scm
}:
let
  # TODO: Ideally we would build pdfium from source (libreoffice also uses it),
  # but it's quite complicated as it's a Chromium project.

  # Full version as published on https://github.com/bblanchon/pdfium-binaries/releases
  pdfiumVersion = "121.9.6110.0";

  supportedPdfiumBinVersions = { # keyed by nixpkgs platform name, also used in `meta.platforms` below
    x86_64-linux = {
      platformFileInfix = "linux-x64";
      hash = "sha256-d1tFlzJuh0q7gzwbVegPngxkiCdL/5kXZTOs/aXATlE=";
    };
  };

  pdfium =
    if !builtins.hasAttr stdenv.hostPlatform.system supportedPdfiumBinVersions
      then throw "Unsupported platform for pypdfium2 (please add it if it's available)."
      else supportedPdfiumBinVersions.${stdenv.hostPlatform.system};

  parsedNumericVersionComponents = # Turns e.g. `"121.9.6110.0"` into `[121 9 6110 0]`.
    let jsonList = map builtins.fromJSON (lib.splitVersion pdfiumVersion);
    in
      assert lib.length jsonList == 4;
      assert lib.all lib.isInt jsonList;
      jsonList;
  pdfiumVersion_major = lib.elemAt parsedNumericVersionComponents 0;
  pdfiumVersion_minor = lib.elemAt parsedNumericVersionComponents 1;
  pdfiumVersion_build = lib.elemAt parsedNumericVersionComponents 2;
  pdfiumVersion_patch = lib.elemAt parsedNumericVersionComponents 3;

  # Contains more than a single dir; `builtins.fetchTarball` and `fetchzip` cannot handle that yet,
  # so we need to manually unpack it below.
  pdfiumPrebuiltTar = (fetchurl {
    url = "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium/${toString pdfiumVersion_build}/pdfium-${pdfium.platformFileInfix}.tgz";
    hash = pdfium.hash;
  });

  pdfium-bin = runCommand "pdfium-bin" {} ''
    mkdir "$out"
    tar xf "${pdfiumPrebuiltTar}" --directory "$out"
  '';

  ctypesgen_pypdfium_fork_package =
    { lib
    , buildPythonApplication
    , fetchFromGitHub
    , toml
    , setuptools-scm
    }:
      buildPythonApplication rec {
        pname = "ctypesgen";
        version = "3a811c28160b7c742f97ee50bfe55b18d4021ca0";

        src = fetchFromGitHub {
          owner = "pypdfium2-team"; # fork needed for `pypdfium2`
          repo = "ctypesgen";
          rev = version;
          hash = "sha256-VqZ7Xn/7mrBjzIA7RUQt4WkrOttJMb4XmFWPpGtPfHY=";
        };

        # This package uses setuptools-scm to derive the version from the git repo (which we don't have),
        # so use this environment variable to set it manually instead.
        SETUPTOOLS_SCM_PRETEND_VERSION = "1.1.1+g${version}"; # we use the most recent tag and append the git version

        doCheck = false;

        propagatedBuildInputs = [
          toml
          setuptools-scm
        ];
      };
  ctypesgen_pypdfium_fork = callPackage ctypesgen_pypdfium_fork_package {};

in buildPythonPackage rec {
  pname = "pypdfium2";
  version = "4.24.0";

  src = fetchFromGitHub {
    owner = "pypdfium2-team";
    repo = "pypdfium2";
    rev = version;
    hash = "sha256-dH7IViCfcYuCLZAuqHkl03aXOeFEjm93zKiRraxGeGQ=";
  };

  # Following instructions from section
  # > With caller-built data files (this is expected to work offline)
  # https://github.com/pypdfium2-team/pypdfium2/tree/30c60af438b7cd90e22d42dd2ba5bffdeb568c42#install-source-caller
  # with the addition of `--compile-libdirs`, which fixes `ctypesgen` warning:
  #     WARNING: Could not load library 'pdfium'. Okay, I'll try to load it at runtime instead.
  preConfigure = ''
    "${ctypesgen_pypdfium_fork}/bin/ctypesgen" \
      --library pdfium \
      --compile-libdirs "${pdfium-bin}/lib" \
      --runtime-libdirs "${pdfium-bin}/lib" \
      --headers "${pdfium-bin}"/include/fpdf*.h \
      -o src/pypdfium2_raw/bindings.py \
      --strip-build-path=. \
      --no-srcinfo

    cat > src/pypdfium2_raw/version.json <<END
    {
      "major": ${toString pdfiumVersion_major},
      "minor": ${toString pdfiumVersion_minor},
      "build": ${toString pdfiumVersion_build},
      "patch": ${toString pdfiumVersion_patch},
      "n_commits": 0,
      "hash": null,
      "origin": "pdfium-binaries/nixos",
      "flags": []
    }
    END

    export PDFIUM_PLATFORM='prepared!system:${toString pdfiumVersion_build}'

    # The `setup.py` invocation uses the `export`ed variables above.
  '';

  propagatedBuildInputs = [
    build
    setuptools-scm
    numpy
    pytest
    pillow
  ];

  meta = with lib; {
    description = "Python bindings to PDFium";
    homepage = "https://pypdfium2.readthedocs.io/";
    license = with licenses; [ asl20 /* or */ bsd3 ];
    maintainers = with maintainers; [ chpatrick nh2 ];
    platforms = builtins.attrNames supportedPdfiumBinVersions;
  };
}
