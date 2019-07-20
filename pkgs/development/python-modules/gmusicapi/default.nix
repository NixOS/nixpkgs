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
  version = "12.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e066f38bbfce068e0e89f34ccdbc7056fd5fdc446d3c33c70f53b26078eb78b";
  };

  propagatedBuildInputs = [ validictory decorator mutagen protobuf setuptools requests dateutil proboscis mock appdirs oauth2client pyopenssl gpsoauth MechanicalSoup future ];

  meta = with stdenv.lib; {
    description = "An unofficial API for Google Play Music";
    homepage = https://pypi.python.org/pypi/gmusicapi/;
    license = licenses.bsd3;
  };
}
