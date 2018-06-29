{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-axolotl-curve25519";
  version = "0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h1rsdr7m8lvgxwrwng7qv0xxmyc9k0q7g9nbcr6ks2ipyjzcnf5";
  };

  meta = with lib; {
    homepage = https://github.com/tgalal/python-axolotl-curve25519;
    description = "Curve25519 with ed25519 signatures";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
