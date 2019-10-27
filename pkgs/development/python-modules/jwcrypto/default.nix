{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a87ac0922d09d9a65011f76d99849f1fbad3d95439c7452cebf4ab0871c2b665";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  meta = with lib; {
    description = "Implementation of JOSE Web standards";
    homepage = https://github.com/latchset/jwcrypto;
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.costrouc ];
  };
}
