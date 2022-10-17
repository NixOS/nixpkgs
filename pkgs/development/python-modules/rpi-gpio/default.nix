{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "rpi-gpio";
  version = "0.7.1";

  src = fetchPypi {
    pname = "RPi.GPIO";
    inherit version;
    sha256 = "sha256-zWHEsDw3tiu6SlrP6phidJwzxhjgKV5+kKpHE/s3O3A=";
  };

  # Tests disable because they do a platform check which requires running on a
  # Raspberry Pi
  doCheck = false;

  meta = with lib; {
    homepage = "https://sourceforge.net/p/raspberry-gpio-python";
    description = "Python module to control the GPIO on a Raspberry Pi";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
