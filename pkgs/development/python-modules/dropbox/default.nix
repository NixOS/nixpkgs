{ stdenv, buildPythonPackage, fetchPypi
, pytestrunner, requests, urllib3, mock, setuptools }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "10.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2312a0314d7698f6aa6944bf6d73a756f4ff7d7d90fa26c323a418a84dc3b533";
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
