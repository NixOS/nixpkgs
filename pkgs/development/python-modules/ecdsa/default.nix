{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, six
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f12ac317f8a1318efa75757ef0a651abe12e51fc1af8838fb91079445227277";
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
