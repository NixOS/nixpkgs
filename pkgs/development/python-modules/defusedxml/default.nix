{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "defusedxml";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hrFdnjxjneefTLOK7/6jKB9ir/eN3n15jhNSxjv6bqA=";
  };
}
