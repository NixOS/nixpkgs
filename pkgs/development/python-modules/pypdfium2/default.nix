{
  stdenv,
  lib,
  pkgsCross,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools-scm,
  pdfium-binaries,
  numpy,
  pillow,
  pytestCheckHook,
  removeReferencesTo,
  python,
}:

let
  # They demand their own fork of ctypesgen
  ctypesgen = buildPythonPackage rec {
    pname = "ctypesgen";
    version = "1.1.1+g${src.rev}"; # the most recent tag + git version
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pypdfium2-team";
      repo = "ctypesgen";
      rev = "3961621c3e057015362db82471e07f3a57822b15";
      hash = "sha256-0OBY7/Zn12rG20jNYG65lANTRVRIFvE0SgUdYGFpRtU=";
    };

    build-system = [
      setuptools-scm
    ];
  };

in
buildPythonPackage rec {
  pname = "pypdfium2";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypdfium2-team";
    repo = "pypdfium2";
    tag = version;
    hash = "sha256-u/bmvik6HRrSksO5QKRAqTr5r/qBPNFlooIZxWNoA+Y=";
  };

  build-system = [
    ctypesgen
    setuptools-scm
  ];

  nativeBuildInputs = [
    removeReferencesTo
  ];

  propagatedBuildInputs = [
    pdfium-binaries
  ];

  preBuild = ''
    getVersion() {
      cat ${pdfium-binaries}/VERSION | grep $1 | sed 's/.*=//'
    }
    export GIVEN_FULLVER="$(getVersion MAJOR).$(getVersion MINOR).$(getVersion BUILD).$(getVersion PATCH)"
  '';

  env = {
    PDFIUM_PLATFORM = "system-search:${pdfium-binaries.version}";
    PDFIUM_HEADERS = "${pdfium-binaries}/include";
    PDFIUM_BINARY = "${pdfium-binaries}/lib/libpdfium${stdenv.targetPlatform.extensions.sharedLibrary}";
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

  pythonImportsCheck = [
    "pypdfium2"
  ];

  passthru = {
    updateScript = gitUpdater {
      allowedVersions = "^[.0-9]+$";
    };
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
