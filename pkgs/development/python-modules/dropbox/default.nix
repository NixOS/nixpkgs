{ stdenv, buildPythonPackage, fetchPypi
, pytestrunner, requests, urllib3, mock, setuptools }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "10.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-INA50DD3wfVPItGCgywZCe5bViatUkaaGdJ0vwcEHgY=";
  };

  # Set DROPBOX_TOKEN environment variable to a valid token.
  doCheck = false;

  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ requests urllib3 mock setuptools ];

  meta = with stdenv.lib; {
    description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = "https://www.dropbox.com/developers/core/docs";
    license = licenses.mit;
  };
}
