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
    sha256 = "494c6a853e9ed2e9be33d160b41d47afc50a6629b993d2b9c5ad7bb226add892";
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
