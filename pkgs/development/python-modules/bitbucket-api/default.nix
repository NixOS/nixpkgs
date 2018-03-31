{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, requests_oauthlib, nose, sh }:

buildPythonPackage rec {
  pname = "bitbucket-api";
  version = "0.4.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cl5xa55ijjd23xs8znsd4w4vb3q1vkbmchy7hh6z6nmjcwbr478";
  };

  propagatedBuildInputs = [ requests_oauthlib nose sh ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/Sheeprider/BitBucket-api;
    description = "Python library to interact with BitBucket REST API";
    license = licenses.mit;
  };
}
