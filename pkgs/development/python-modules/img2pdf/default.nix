{ lib, pillow, fetchPypi, buildPythonPackage, isPy27, pikepdf }:

buildPythonPackage rec {
  pname = "img2pdf";
  version = "0.4.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jlHFBD76lddRSBtRYHGgBvh8KkBZlhqaxD7COJFd4J8=";
  };

  propagatedBuildInputs = [
    pikepdf
    pillow
  ];

  # no tests exectuted
  doCheck = false;

  meta = with lib; {
    description = "Convert images to PDF via direct JPEG inclusion";
    homepage = "https://gitlab.mister-muffin.de/josch/img2pdf";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
  };
}
