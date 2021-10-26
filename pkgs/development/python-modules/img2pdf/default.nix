{ lib, pillow, fetchPypi, buildPythonPackage, isPy27, pikepdf }:

buildPythonPackage rec {
  pname = "img2pdf";
  version = "0.4.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qs9YZQPWET5Tv7A8hcheVGw4RBOlbBXd0I7lHIZEeaI=";
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
