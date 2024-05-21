{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-axolotl-curve25519";
  version = "0.4.1.post2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0705a66297ebd2f508a60dc94e22881c754301eb81db93963322f6b3bdcb63a3";
  };

  meta = with lib; {
    homepage = "https://github.com/tgalal/python-axolotl-curve25519";
    description = "Curve25519 with ed25519 signatures";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
