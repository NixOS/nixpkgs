{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Cheetah3";
  version = "3.2.6.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58b5d84e5fbff6cf8e117414b3ea49ef51654c02ee887d155113c5b91d761967";
  };

  doCheck = false; # Circular dependency

  meta = with lib; {
    homepage = "http://www.cheetahtemplate.org/";
    description = "A template engine and code generation tool";
    license = licenses.mit;
    maintainers = with maintainers; [ pjjw ];
  };
}
