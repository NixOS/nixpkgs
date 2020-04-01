{ stdenv, buildPythonPackage, fetchPypi, isPy27, pyserial, srp, lib }:

buildPythonPackage rec {
  pname = "digi-xbee";
  version = "1.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ed798faee0853bf7ae9ca5aa4bdcbab496e3c2d56c9f0719a8e3e0d13270891";
  };

  propagatedBuildInputs = [ pyserial srp ];

  # Upstream doesn't contain unit tests, only functional tests which require specific hardware
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python library to interact with Digi International's XBee radio frequency modules";
    homepage = "https://github.com/digidotcom/xbee-python";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jefflabonte ];
  };
}
