{ stdenv, buildPythonPackage, fetchPypi, requests, oauthlib }:

buildPythonPackage rec {
  pname = "discogs-client";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n23xy33fdp3dq0hhfdg0lx4z7rhdi74ik8v1mc7rql1jbxl7bmf";
  };

  propagatedBuildInputs = [ requests oauthlib ];

  meta = with stdenv.lib; {
    description = "Official Python API client for Discogs";
    license = licenses.bsd2;
    homepage = "https://github.com/discogs/discogs_client";
  };
}
