{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-il8vAAIcSscuTauRDcGGPA4Aii5/tchDkzrpvPw9CAI=";
  };

  meta = with lib; {
    homepage = "https://github.com/scoder/fastrlock";
    description = "A fast RLock implementation for CPython";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
