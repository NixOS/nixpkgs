{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7fee2635bbefdf145399392f5be26ad54161c8271c66b5fe107b4b452f06c24";
  };

  requiredPythonModules = [
    cryptography
  ];

  meta = with lib; {
    description = "Implementation of JOSE Web standards";
    homepage = "https://github.com/latchset/jwcrypto";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.costrouc ];
  };
}
