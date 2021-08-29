{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "retry_decorator";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1e8ad02e518fe11073f2ea7d80b6b8be19daa27a60a1838aff7c731ddcf2ebe";
  };

  meta = with lib; {
    homepage = "https://github.com/pnpnpn/retry-decorator";
    description = "Retry Decorator for python functions";
    license = licenses.mit;
  };

}
