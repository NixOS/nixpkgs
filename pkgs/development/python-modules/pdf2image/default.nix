{ lib
, buildPythonPackage
, fetchPypi
, pillow
, poppler_utils
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pdf2image";
  version = "1.16.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hnYQke7jX0ZB6pjf3bJUJUNh0Bi+aYoZmv98HTczGAM=";
  };

  postPatch = ''
    # Only replace first match in file
    sed -i '0,/poppler_path=None/s||poppler_path="${poppler_utils}/bin"|' pdf2image/pdf2image.py
  '';

  propagatedBuildInputs = [
    pillow
  ];

  pythonImportsCheck = [
    "pdf2image"
  ];

  meta = with lib; {
    description = "Module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = "https://github.com/Belval/pdf2image";
    changelog = "https://github.com/Belval/pdf2image/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
