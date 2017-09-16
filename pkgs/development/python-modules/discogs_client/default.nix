{ stdenv, buildPythonPackage, fetchPypi, requests, oauthlib }:

buildPythonPackage rec {
  pname = "discogs-client";
  version = "2.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kjm4zyxlkv8cjyd4zl0yslbkmfz4ga9nm3d2glpw3nmvmvajn40";
  };

  propagatedBuildInputs = [ requests oauthlib ];

  meta = with stdenv.lib; {
    description = "Official Python API client for Discogs";
    license = licenses.bsd2;
    homepage = "https://github.com/discogs/discogs_client";
  };
}
