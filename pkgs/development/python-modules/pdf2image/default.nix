{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  poppler_utils,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pdf2image";
  version = "1.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6qlZvBFrQg3X7EFfyuSbmBAN2j3RjNL9+obQnxEvbVc=";
  };

  postPatch = ''
    # Only replace first match in file
    sed -i '0,/poppler_path=None/s||poppler_path="${poppler_utils}/bin"|' pdf2image/pdf2image.py
  '';

  propagatedBuildInputs = [ pillow ];

  pythonImportsCheck = [ "pdf2image" ];

  meta = with lib; {
    description = "Module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = "https://github.com/Belval/pdf2image";
    changelog = "https://github.com/Belval/pdf2image/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
