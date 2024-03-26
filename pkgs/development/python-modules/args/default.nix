{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "args";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814";
  };

  meta = with lib; {
    description = "Command Arguments for Humans";
    homepage = "https://github.com/kennethreitz/args";
  };
}
