{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "retry_decorator";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7723b83730a09a5a884f2d1c422c9556d20324b7a0f5b129ad94fd07baba36d";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/pnpnpn/retry-decorator;
    description = "Retry Decorator for python functions";
    license = licenses.mit;
  };

}
