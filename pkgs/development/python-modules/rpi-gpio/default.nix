{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rpi-gpio";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "RPi.GPIO";
    inherit version;
    hash = "sha256-zWHEsDw3tiu6SlrP6phidJwzxhjgKV5+kKpHE/s3O3A=";
  };

  # Tests disable because they do a platform check which requires running on a
  # Raspberry Pi
  doCheck = false;

  meta = {
    homepage = "https://sourceforge.net/p/raspberry-gpio-python";
    description = "Python module to control the GPIO on a Raspberry Pi";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
  };
}
