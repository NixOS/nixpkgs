{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "defusedxml";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f684034d135af4c6cbb949b8a4d2ed61634515257a67299e5f940fbaa34377f5";
  };
}
