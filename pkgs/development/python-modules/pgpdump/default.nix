{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pgpdump";
  version = "1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s4nh8h7qsdj2yf29bspjs1zvxd4lcd11r6g11dp7fppgf2h0iqw";
  };

  # Disabling check because of: https://github.com/toofishes/python-pgpdump/issues/18
  doCheck = false;

  meta = with lib; {
    description = "Python library for parsing PGP packets";
    homepage = "https://github.com/toofishes/python-pgpdump";
    license = licenses.bsd3;
  };
}
