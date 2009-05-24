a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.8" a; 
  propagatedBuildInputs = with a; [
    openssl python
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/sourceforge/pyopenssl/pyOpenSSL-${version}.tar.gz";
    sha256 = "1qzzycjyp1qsw87msj9kg2q3h7il1bf4jkrwy841y0zi44fl3112";
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
