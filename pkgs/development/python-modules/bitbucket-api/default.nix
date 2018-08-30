{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, requests_oauthlib, nose, sh }:

buildPythonPackage rec {
  pname = "bitbucket-api";
  version = "0.5.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b541d9d7f234074a74214505aff1846eb21e5dd6d3915139e817d4675d34f4e3";
  };

  propagatedBuildInputs = [ requests_oauthlib nose sh ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/Sheeprider/BitBucket-api;
    description = "Python library to interact with BitBucket REST API";
    license = licenses.mit;
  };
}
