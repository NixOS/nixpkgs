{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f88816eb0a41b8f006af978ced5f171f33782525006cdb055b536a40f4d46ac9";
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
