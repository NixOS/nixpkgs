{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DWRhuhP3wnHYusUBjuYN28rl/zlAP6+kI3X1fQjjmLs=";
  };

  propagatedBuildInputs = [
    cryptography
    deprecated
  ];

  meta = with lib; {
    description = "Implementation of JOSE Web standards";
    homepage = "https://github.com/latchset/jwcrypto";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.costrouc ];
  };
}
