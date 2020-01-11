{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "163c80b064a763ea733870feb96f9dd9b92216cfcacd374837af18e4e8ec3d4d";
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
