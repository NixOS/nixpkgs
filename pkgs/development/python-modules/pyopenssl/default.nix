a :
let
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.10" a;
  propagatedBuildInputs = with a; [
    openssl python
  ];
in
rec {
  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.10.tar.gz";
    sha256 = "4514f8960389042ca2587f9cb801a13f7990387753fc678680b0c084719b5b60";
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
