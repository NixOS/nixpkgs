{ stdenv, buildPythonPackage, fetchPypi
, jsonschema }:

buildPythonPackage rec {
  pname = "jsonmerge";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c05229545d55c1bbfdb3fa11c7f8a1c9868c713af209059ac48e7d86fa9c6a1f";
  };

  propagatedBuildInputs = [ jsonschema ];

  meta = with stdenv.lib; {
    description = "Merge a series of JSON documents";
    homepage = "https://github.com/avian2/jsonmerge";
    license = licenses.mit;
  };
}
