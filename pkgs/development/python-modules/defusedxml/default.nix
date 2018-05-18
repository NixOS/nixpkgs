{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "defusedxml";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x54n0h8hl92vvwyymx883fbqpqjwn2mc8fb383bcg3z9zwz5mr4";
  };
}
