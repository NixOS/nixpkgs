{
  lib,
  stdenv,
  python27,
  callPackage,
  fetchFromGitHub,
  makeWrapper,
  re2c,
  # oil deps
  glibcLocales,
  file,
  six,
  typing,
}:

rec {
  /*
    Upstream isn't interested in packaging this as a library
    (or accepting all of the patches we need to do so).
    This creates one without disturbing upstream too much.
  */
  oildev = python27.pkgs.buildPythonPackage rec {
    pname = "oildev-unstable";
    version = "2024-02-26";

    src = fetchFromGitHub {
      owner = "oilshell";
      repo = "oil";
      # rev == present HEAD of release/0.20.0
      rev = "f730c79e2dcde4bc08e85a718951cfa42102bd01";
      hash = "sha256-HBj3Izh1gD63EzbgZ/9If5vihR5L2HhnyCyMah6rMg4=";

      /*
        It's not critical to drop most of these; the primary target is
        the vendored fork of Python-2.7.13, which is ~ 55M and over 3200
        files, dozens of which get interpreter script patches in fixup.

        Note: -f is necessary to keep it from being a pain to update
        hash on rev updates. Command will fail w/o and not print hash.
      */
      postFetch = ''
        rm -rf $out/{Python-2.7.13,metrics,py-yajl,rfc,gold,web,testdata,services,demo}
      '';
    };

    # patch to support a python package, pass tests on macOS, drop deps, etc.
    patchSrc = fetchFromGitHub {
      owner = "abathur";
      repo = "nix-py-dev-oil";
      rev = "v0.20.0.0";
      hash = "sha256-qoA54rnzAdnFZ3k4kRzQWEdgtEjraCT5+NFw8AWnRDk=";
    };

    patches = [
      "${patchSrc}/0001-add_setup_py.patch"
      "${patchSrc}/0002-add_MANIFEST_in.patch"
      "${patchSrc}/0006-disable_failing_libc_tests.patch"
      "${patchSrc}/0007-namespace_via_init.patch"
      "${patchSrc}/0009-avoid_nix_arch64_darwin_toolchain_bug.patch"
      "${patchSrc}/0010-disable-line-input.patch"
      "${patchSrc}/0011-disable-fanos.patch"
      "${patchSrc}/0012-disable-doc-cmark.patch"
      "${patchSrc}/0013-fix-pyverify.patch"
      "${patchSrc}/0015-fix-compiled-extension-import-paths.patch"
    ];

    configureFlags = [
      "--without-readline"
    ];

    nativeBuildInputs = [
      re2c
      file
      makeWrapper
    ];

    propagatedBuildInputs = [
      six
      typing
    ];

    doCheck = true;

    preBuild = ''
      build/py.sh all
    '';

    postPatch = ''
      patchShebangs asdl build core doctools frontend pyext oil_lang ysh
      rm cpp/stdlib.h # keep modules from finding the wrong stdlib?
      # work around hard parse failure documented in oilshell/oil#1468
      substituteInPlace osh/cmd_parse.py --replace 'elif self.c_id == Id.Op_LParen' 'elif False'
    '';

    # See earlier note on glibcLocales TODO: verify needed?
    LOCALE_ARCHIVE = lib.optionalString (
      stdenv.buildPlatform.libc == "glibc"
    ) "${glibcLocales}/lib/locale/locale-archive";

    # not exhaustive; sample what resholve uses as a sanity check
    pythonImportsCheck = [
      "oil"
      "oil.asdl"
      "oil.core"
      "oil.frontend"
      "oil._devbuild"
      "oil._devbuild.gen.id_kind_asdl"
      "oil._devbuild.gen.syntax_asdl"
      "oil.osh"
      "oil.tools.ysh_ify"
    ];

    meta = {
      license = with lib.licenses; [
        psfl # Includes a portion of the python interpreter and standard library
        asl20 # Licence for Oil itself
      ];
    };
  };
}
