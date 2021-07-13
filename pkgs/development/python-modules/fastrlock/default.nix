{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f5d6ec9fe130b7490bb04572134392420b72bd0842185e02d461a797d6bc749";
  };

  meta = with lib; {
    homepage = "https://github.com/scoder/fastrlock";
    description = "A fast RLock implementation for CPython";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
