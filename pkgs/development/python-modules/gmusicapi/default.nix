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
  version = "11.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0345df8119c4721cabafff765fe9ded1a246886f5a67b1b306c656b685650b8";
  };

  propagatedBuildInputs = [ validictory decorator mutagen protobuf setuptools requests dateutil proboscis mock appdirs oauth2client pyopenssl gpsoauth MechanicalSoup future ];

  meta = with stdenv.lib; {
    description = "An unofficial API for Google Play Music";
    homepage = https://pypi.python.org/pypi/gmusicapi/;
    license = licenses.bsd3;
  };
}
