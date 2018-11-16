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
  version = "10.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0smlrafh1bjzrcjzl7im8pf8f04gcnx92lf3g5qr7yzgq8k20xa2";
  };

  propagatedBuildInputs = [ validictory decorator mutagen protobuf setuptools requests dateutil proboscis mock appdirs oauth2client pyopenssl gpsoauth MechanicalSoup future ];

  meta = with stdenv.lib; {
    description = "An unofficial API for Google Play Music";
    homepage = https://pypi.python.org/pypi/gmusicapi/;
    license = licenses.bsd3;
  };
}
