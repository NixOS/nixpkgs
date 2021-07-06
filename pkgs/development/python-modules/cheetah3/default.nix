{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Cheetah3";
  version = "3.2.6.post2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63157d7a00a273b59676b5be5aa817c75c37efc88478231f1a160f4cfb7f7878";
  };

  doCheck = false; # Circular dependency

  meta = with lib; {
    homepage = "http://www.cheetahtemplate.org/";
    description = "A template engine and code generation tool";
    license = licenses.mit;
    maintainers = with maintainers; [ pjjw ];
  };
}
