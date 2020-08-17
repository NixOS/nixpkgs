{ lib, pillow, fetchPypi, buildPythonPackage, isPy27, pikepdf }:

buildPythonPackage rec {
  pname = "img2pdf";
  version = "0.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eaee690ab8403dd1a9cb4db10afee41dd3e6c7ed63bdace02a0121f9feadb0c9";
  };

  propagatedBuildInputs = [
    pikepdf
    pillow
  ];

  meta = with lib; {
    description = "Convert images to PDF via direct JPEG inclusion";
    homepage = "https://gitlab.mister-muffin.de/josch/img2pdf";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
  };
}
