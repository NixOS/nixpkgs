{ stdenv, buildPythonPackage, fetchPypi
, pytestrunner, requests, urllib3, mock, setuptools }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "8.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "019f1529631d335f2b57ffd65a4545406bd3d139d0a9611cb6ca8c66c4ae7309";
  };

  # Set DROPBOX_TOKEN environment variable to a valid token.
  doCheck = false;

  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ requests urllib3 mock setuptools ];

  meta = with stdenv.lib; {
    description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = https://www.dropbox.com/developers/core/docs;
    license = licenses.mit;
  };
}
