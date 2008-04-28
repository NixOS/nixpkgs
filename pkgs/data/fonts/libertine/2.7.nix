args : with args; 
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/linuxlibertine/LinLibertineSRC-2.7.tgz;
    sha256 = "1czc3pil4zrii6qh6zk0g6hj6axj20gfnpbbdfrzm703wm9w70ic";
  };

  buildInputs = [fontforge];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doUnpack" "generateFontsFromSFD" "installFonts"];
      
  createTTF=false;

  name = "linux-libertine-" + version;
  meta = {
    description = "Linux Libertine Fonts";
    homepage = http://linuxlibertine.sf.net;
  };
}
