{ stdenv, buildPythonPackage, fetchPypi, requests, oauthlib }:

buildPythonPackage rec {
  pname = "discogs-client";
  version = "2.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e32b5e45cff41af8025891c71aa3025b3e1895de59b37c11fd203a8af687414";
  };

  propagatedBuildInputs = [ requests oauthlib ];

  meta = with stdenv.lib; {
    description = "Official Python API client for Discogs";
    license = licenses.bsd2;
    homepage = "https://github.com/discogs/discogs_client";
  };
}
