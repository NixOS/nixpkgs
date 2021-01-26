{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Cheetah3";
  version = "3.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1c2b693cdcac2ded2823d363f8459ae785261e61c128d68464c8781dba0466b";
  };

  doCheck = false; # Circular dependency

  meta = with lib; {
    homepage = "http://www.cheetahtemplate.org/";
    description = "A template engine and code generation tool";
    license = licenses.mit;
    maintainers = with maintainers; [ pjjw ];
  };
}
