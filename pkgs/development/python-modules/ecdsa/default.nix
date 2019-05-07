{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c034ffa23413ac923541ceb3ac14ec15a0d2530690413bff58c12b80e56d884";
  };

  # Only needed for tests
  checkInputs = [ pkgs.openssl ];

  meta = with stdenv.lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig ];
  };

}
