{ lib, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  name = "python-axolotl-curve25519-${version}";
  version = "0.1";

  src = fetchurl {
    url = "mirror://pypi/p/python-axolotl-curve25519/${name}.tar.gz";
    sha256 = "1h1rsdr7m8lvgxwrwng7qv0xxmyc9k0q7g9nbcr6ks2ipyjzcnf5";
  };

  meta = with lib; {
    homepage = https://github.com/tgalal/python-axolotl-curve25519;
    description = "Curve25519 with ed25519 signatures";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
