{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "curve25519-donna";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w0vkjyh4ki9n98lr2hg09f1lr1g3pz48kshrlic01ba6pasj60q";
  };

  meta = with lib; {
    description = "Python wrapper for the portable curve25519-donna implementation";
    homepage = "http://code.google.com/p/curve25519-donna/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
