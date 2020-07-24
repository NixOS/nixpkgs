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
  version = "13.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14dqs64nhy84dykyyrdjmsirc7m169zsvwa8abh4v0xcm658lm5k";
  };

  propagatedBuildInputs = [ validictory decorator mutagen protobuf setuptools requests dateutil proboscis mock appdirs oauth2client pyopenssl gpsoauth MechanicalSoup future ];

  meta = with stdenv.lib; {
    description = "An unofficial API for Google Play Music";
    homepage = "https://pypi.python.org/pypi/gmusicapi/";
    license = licenses.bsd3;
  };
}
