{
  stdenv,
  lib,
  pkgsCross,
  buildPythonPackage,
  common-updater-scripts,
  coreutils,
  curl,
  diffutils,
  fetchFromGitHub,
  gnutar,
  gzip,
  jq,
  nix,
  nix-update,
  packaging,
  setuptools,
  pdfium,
  numpy,
  pillow,
  pytestCheckHook,
  removeReferencesTo,
  python,
  writeShellApplication,
}:

let
  # Use the fork revision bundled with this release's source distribution.
  ctypesgen = fetchFromGitHub {
    owner = "pypdfium2-team";
    repo = "ctypesgen";
    rev = "4ddc2b2cdc4daefb0be450e8b5152e11337e9e3c";
    hash = "sha256-S98kIimLZa3wJ5aKlADYOkqxsOhUlLqLHogC7Id0vVo=";
  };
in
buildPythonPackage rec {
  pname = "pypdfium2";
  version = "5.14.0";
  pyproject = true;

  # Use GitHub because the PyPI source distribution excludes the test suite.
  src = fetchFromGitHub {
    owner = "pypdfium2-team";
    repo = "pypdfium2";
    tag = version;
    hash = "sha256-KnZkIbV1ke0tL+VdUOkHElZXVrJixNBBoD0fpLPHNbY=";
  };

  build-system = [
    packaging
    setuptools
  ];

  postPatch = ''
    mkdir -p deps
    ln -s ${ctypesgen} deps/ctypesgen
  '';

  nativeBuildInputs = [
    removeReferencesTo
  ];

  propagatedBuildInputs = [
    pdfium
  ];

  env = {
    GIVEN_FULLVER = pdfium.fullVersion;
    PDFIUM_PLATFORM = "system-search:${pdfium.version}";
    PDFIUM_HEADERS = "${lib.getDev pdfium}/include/public";
    PDFIUM_BINARY = "${lib.getLib pdfium}/lib/libpdfium${stdenv.targetPlatform.extensions.sharedLibrary}";
    CPP = "${stdenv.cc.targetPrefix}cpp";
  };

  # Remove references to stdenv in comments.
  postInstall = ''
    remove-references-to -t ${stdenv.cc.cc} $out/${python.sitePackages}/pypdfium2_raw/bindings.py
  '';

  nativeCheckInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  # Avoid collecting ctypesgen's tests, which also define tests.conftest.
  enabledTestPaths = [ "tests" ];

  disabledTestPaths = [
    # does not work on ZFS with normalization
    "tests/test_opener.py::test_open_garbled_filename"
  ];

  pythonImportsCheck = [
    "pypdfium2"
  ];

  passthru = {
    inherit ctypesgen;

    updateScript = lib.getExe (writeShellApplication {
      name = "pypdfium2-update";
      runtimeInputs = [
        common-updater-scripts
        coreutils
        curl
        diffutils
        gnutar
        gzip
        jq
        nix
        nix-update
      ];
      text = builtins.readFile ./update.sh;
    });
    tests.cross = pkgsCross.aarch64-multiplatform.python3Packages.pypdfium2;
  };

  meta = {
    changelog = "https://github.com/pypdfium2-team/pypdfium2/releases/tag/${version}";
    description = "Python bindings to PDFium";
    homepage = "https://pypdfium2.readthedocs.io/";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ booxter ];
  };
}
