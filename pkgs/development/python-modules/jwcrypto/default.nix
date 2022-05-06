{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7fQwkyFyHlFhzvzN1ksEUJ4Dkk/q894IW0d4B2WYmuM=";
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
