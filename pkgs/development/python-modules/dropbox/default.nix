{ stdenv, buildPythonPackage, fetchPypi
, pytestrunner, requests, urllib3, mock, setuptools }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "10.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08c1e0bbc16499e0138431e34777c35ea086734ff15ee5067b0df3424df2a9ec";
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
