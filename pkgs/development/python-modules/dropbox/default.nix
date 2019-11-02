{ stdenv, buildPythonPackage, fetchPypi
, pytestrunner, requests, urllib3, mock, setuptools }:

buildPythonPackage rec {
  pname = "dropbox";
  version = "9.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qid094qna6bl4zpd08f6snvipwjls1yadacvmwri11djgp0wvj3";
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
