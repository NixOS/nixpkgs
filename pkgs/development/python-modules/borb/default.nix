{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, fonttools
, lxml
, pillow
, python-barcode
, pythonOlder
, qrcode
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "borb";
  version = "2.1.22";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T+uSq/KF3p4zJJhQeompJIJ6BWhYFK9Ko9w0sZFtFhE=";
  };

  propagatedBuildInputs = [
    cryptography
    fonttools
    lxml
    pillow
    python-barcode
    qrcode
    requests
    setuptools
  ];

  pythonImportsCheck = [
    "borb.pdf"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Library for reading, creating and manipulating PDF files in Python";
    homepage = "https://borbpdf.com/";
    changelog = "https://github.com/jorisschellekens/borb/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ marsam ];
  };
}
