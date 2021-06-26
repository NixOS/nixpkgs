{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63531529218ba9869e14ef8c9e7b516865ede3facf9b0ef3d3ba68014da211f9";
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
