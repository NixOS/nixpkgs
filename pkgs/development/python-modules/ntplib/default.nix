{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ntplib";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4621b64d50be9461d9bd9a71ba0b4af06fbbf818bbd483752d95c1a4e273ede";
  };

  # Require networking
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python NTP library";
    homepage = http://code.google.com/p/ntplib/;
    license = licenses.mit;
  };

}
