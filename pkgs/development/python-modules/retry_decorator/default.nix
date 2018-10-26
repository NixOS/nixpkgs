{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "retry_decorator";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "086zahyb6yn7ggpc58909c5r5h3jz321i1694l1c28bbpaxnlk88";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/pnpnpn/retry-decorator;
    description = "Retry Decorator for python functions";
    license = licenses.mit;
  };

}
