a :
let
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.13" a;
  propagatedBuildInputs = with a; [
    openssl python
  ];
in
rec {
  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-${version}.tar.gz";
    sha256 = "21e12b03abaa0e04ecc8cd9c251598f71bae11c9f385304234e4ea5618c6163b";
  };

  inherit propagatedBuildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["installPythonPackage"];

  name = "pyOpenSSL-" + version;
  meta = {
    description = "Python OpenSSL wrapper capable of checking certificates";
  };
}
