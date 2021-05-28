{ stdenv, buildPythonPackage, fetchPypi, requests, oauthlib }:

buildPythonPackage rec {
  pname = "discogs-client";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc979fcbb5283f74d388c7111c8ed6bef920b01614a014d6b1c5d6fbb554bfc3";
  };

  propagatedBuildInputs = [ requests oauthlib ];

  meta = with stdenv.lib; {
    description = "Official Python API client for Discogs";
    license = licenses.bsd2;
    homepage = "https://github.com/discogs/discogs_client";
  };
}
