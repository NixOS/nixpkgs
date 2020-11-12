{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, six
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14nqmlkb4yxdqnwx54xr55k0midg8wfv8q6i6fzfklly7s2nlk29";
  };

  propagatedBuildInputs = [ six ];
  # Only needed for tests
  checkInputs = [ pkgs.openssl ];

  meta = with stdenv.lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = licenses.mit;
  };

}
