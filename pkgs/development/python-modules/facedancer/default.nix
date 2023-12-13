{ lib, buildPythonPackage, fetchPypi, isPy3k, pyusb, pyserial }:

buildPythonPackage rec {
  pname = "facedancer";
  version = "2019.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zhwnlfksblgp54njd9gjsrr5ibg12cx1x9xxcqkcdfhn3m2kmm0";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ pyusb pyserial ];

  preBuild = ''
    echo "$version" > VERSION
  '';

  meta = with lib; {
    description = "library for emulating usb devices";
    homepage = "https://greatscottgadgets.com/greatfet/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mog ];
  };
}
