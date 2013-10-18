args : with args; 
let version = lib.attrByPath ["version"] "2.04" args; in
rec {
  src = fetchurl {
    urls = [
      "ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/ttf-arkpandora-${version}.tgz"
      "http://www.users.bigpond.net.au/gavindi/ttf-arkpandora-${version}.tgz"
      ];
    sha256 = "16mfxwlgn6vs3xn00hha5dnmz6bhjiflq138y4zcq3yhk0y9bz51";
  };

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doUnpack" "installFonts"];
      
  name = "arkpandora-" + version;
  meta = {
    description = "Font, metrically identical to Arial and Times New Roman";
  };
}
