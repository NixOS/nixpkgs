{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "node-semver";

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p7ink1wajkc31r05k1yn37gk377033a9vhin8v4j757d4ha1f91";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/podhmo/python-semver;
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
