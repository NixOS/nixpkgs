a :
let
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.13.1" a;
  propagatedBuildInputs = with a; [
    openssl python
  ];
in
rec {
  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-${version}.tar.gz";
    sha256 = "1nrg2kas0wsv65j8sia8zkkc6ir5i20lrhkfavjxzxhl0iqyq1ms";
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
