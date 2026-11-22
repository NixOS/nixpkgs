{
  stdenv,
  lib,
  pkgsCross,
  buildPythonPackage,
  fetchPypi,
  packaging,
  setuptools,
  pdfium,
  numpy,
  pillow,
  pytestCheckHook,
  removeReferencesTo,
  python,
}:

buildPythonPackage rec {
  pname = "pypdfium2";
  version = "5.15.1";
  pyproject = true;

  # Use pypi source distribution because it includes their ctypegen fork,
  # which saves us some hassle keeping multiple checkouts aligned.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tGVqDvziG+fyQpA4zj+7QXZEVl/FCFjmWq7SOAHzPUI=";
  };

  build-system = [
    packaging
    setuptools
  ];

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

  # The source distribution omits this empty directory used by the tests.
  preCheck = ''
    mkdir -p tests/output
  '';

  enabledTestPaths = [ "tests" ];

  disabledTestPaths = [
    # does not work on ZFS with normalization
    "tests/test_opener.py::test_open_garbled_filename"
  ];

  pythonImportsCheck = [
    "pypdfium2"
  ];

  passthru = {
    tests.cross = pkgsCross.aarch64-multiplatform.python3Packages.pypdfium2;
  };

  meta = {
    changelog = "https://github.com/pypdfium2-team/pypdfium2/releases/tag/${version}";
    description = "Python bindings to PDFium";
    homepage = "https://pypdfium2.readthedocs.io/";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ booxter ];
  };
}
