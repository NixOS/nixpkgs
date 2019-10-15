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
  version = "12.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cgjxqi4a18zp5dx7v71h6wiy3cvggyydkrs008dsfgyhg8s89d8";
  };

  propagatedBuildInputs = [ validictory decorator mutagen protobuf setuptools requests dateutil proboscis mock appdirs oauth2client pyopenssl gpsoauth MechanicalSoup future ];

  meta = with stdenv.lib; {
    description = "An unofficial API for Google Play Music";
    homepage = https://pypi.python.org/pypi/gmusicapi/;
    license = licenses.bsd3;
  };
}
