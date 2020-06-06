{ buildPythonPackage, fetchPypi, lib, future, pyserial, ipaddress }:

buildPythonPackage rec {
  pname = "pyspinel";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cbfd0f6e9ef3b5cd3a4e72a9a0cee1fe50d518b43746be07a1fd17e883328c2";
  };

  propagatedBuildInputs = [ pyserial ipaddress future ];

  doCheck = false;

  meta = {
    description = "Interface to the OpenThread Network Co-Processor (NCP)";
    homepage = "https://github.com/openthread/pyspinel";
    maintainers = with lib.maintainers; [ gebner ];
  };
}
