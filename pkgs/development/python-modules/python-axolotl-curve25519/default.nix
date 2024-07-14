{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "python-axolotl-curve25519";
  version = "0.4.1.post2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BwWmYpfr0vUIpg3JTiKIHHVDAeuB25OWMyL2s73LY6M=";
  };

  meta = with lib; {
    homepage = "https://github.com/tgalal/python-axolotl-curve25519";
    description = "Curve25519 with ed25519 signatures";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
