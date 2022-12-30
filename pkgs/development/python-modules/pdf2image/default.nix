{ lib, buildPythonPackage, fetchPypi, pillow, poppler_utils }:

buildPythonPackage rec {
  pname = "pdf2image";
  version = "1.16.1";

  propagatedBuildInputs = [ pillow ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eI21otNHmqHtD/U8ilL6v+Ua/26yvnuL/79MG+3LNUc=";
  };

  postPatch = ''
    # Only replace first match in file
    sed -i '0,/poppler_path=None/s||poppler_path="${poppler_utils}/bin"|' pdf2image/pdf2image.py
  '';

  meta = with lib; {
    description = "A python module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = "https://github.com/Belval/pdf2image";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
