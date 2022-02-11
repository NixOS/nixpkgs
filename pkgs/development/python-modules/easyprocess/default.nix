{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "EasyProcess";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "115rzzr0hx4af4m6krf7dxn8851n4l8jfxahjzjc2r0zq2m8v57v";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Easy to use python subprocess interface";
    homepage = "https://github.com/ponty/EasyProcess";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
