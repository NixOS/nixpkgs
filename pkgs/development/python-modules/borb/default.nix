{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  fonttools,
  lxml,
  matplotlib,
  pandas,
  pillow,
  python-barcode,
  pythonOlder,
  qrcode,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "borb";
  version = "2.1.24";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jorisschellekens";
    repo = "borb";
    rev = "refs/tags/v${version}";
    hash = "sha256-3PZ3fHsq9pgJ4oK42Y4b/3ghuYELgRPe09fciOKknuE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    fonttools
    lxml
    pillow
    python-barcode
    qrcode
    requests
    setuptools
  ];

  nativeCheckInputs = [
    matplotlib
    pandas
    pytestCheckHook
  ];

  pythonImportsCheck = [ "borb.pdf" ];

  disabledTests = [
    "test_code_files_are_small "
    "test_image_has_pdfobject_methods"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/pdf/"
    "tests/toolkit/"
    "tests/license/"
  ];

  meta = with lib; {
    description = "Library for reading, creating and manipulating PDF files in Python";
    homepage = "https://borbpdf.com/";
    changelog = "https://github.com/jorisschellekens/borb/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
  };
}
