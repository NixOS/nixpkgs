{ stdenv
, buildPythonPackage
, fetchPypi
, validictory
, decorator
, mutagen
, protobuf
, setuptools
, requests
, dateutil
, proboscis
, mock
, appdirs
, oauth2client
, pyopenssl
, gpsoauth
, MechanicalSoup
, future
}:

buildPythonPackage rec {
  pname = "gmusicapi";
  version = "11.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ffa3892ee39a110e48a383b2e571a72a12109bf978985020fe56e334e45c72c";
  };

  propagatedBuildInputs = [ validictory decorator mutagen protobuf setuptools requests dateutil proboscis mock appdirs oauth2client pyopenssl gpsoauth MechanicalSoup future ];

  meta = with stdenv.lib; {
    description = "An unofficial API for Google Play Music";
    homepage = https://pypi.python.org/pypi/gmusicapi/;
    license = licenses.bsd3;
  };
}
