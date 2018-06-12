{ stdenv, buildPythonPackage, fetchPypi
, pytestrunner, requests, urllib3, mock, setuptools }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "8.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7eeac47f35e73b34023b7a3089380e74bacd0cce4b57e1e347539dfb53681d2";
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
