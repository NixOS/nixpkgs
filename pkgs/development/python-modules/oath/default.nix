{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "oath";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd6b20d20f2c4e3f53523ee900211dca75aeeca72f4f5a9fd8dcacc175fe1c0b";
  };

  meta = with lib; {
    description = "Python implementation of the three main OATH specifications: HOTP, TOTP and OCRA";
    homepage = "https://github.com/bdauvergne/python-oath";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aw ];
  };
}
