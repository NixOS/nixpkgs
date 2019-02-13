{ stdenv, buildPythonPackage, fetchPypi
, pytestrunner, requests, urllib3, mock, setuptools }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "9.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ckpbksdby70d70m58b904h8y8v7m82h12n3q3qk58r4yrqwvld5";
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
