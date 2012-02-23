{ stdenv, fetchsvn, curl }:

let rev = "2262"; in
stdenv.mkDerivation {
  name = "xmlrpc-c-r${rev}";

  buildInputs = [ curl ];

  preInstall = "export datarootdir=$out/share";

  src = fetchsvn {
    url = http://xmlrpc-c.svn.sourceforge.net/svnroot/xmlrpc-c/advanced;
    rev = "2262";
    sha256 = "1grwnczp5dq3w20rbz8bgpwl6jmw0w7cm7nbinlasf3ap5sc5ahb";
  };
}
