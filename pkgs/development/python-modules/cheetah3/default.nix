{ lib, buildPythonPackage, fetchPypi, stdenv }:

buildPythonPackage rec {
  pname = "Cheetah3";
  version = "3.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ececc9ca7c58b9a86ce71eb95594c4619949e2a058d2a1af74c7ae8222515eb1";
  };

  doCheck = false; # Circular dependency

  meta = {
    homepage = "http://www.cheetahtemplate.org/";
    description = "A template engine and code generation tool";
    license = lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ pjjw ];
  };
}
