args: with args;
rec{
  src = fetchurl {
    url = http://downloads.sourceforge.net/linuxlibertine/LinLibertineFont-2.7.tgz;
    sha256 = "06xm3np2xx41fr2yc00q0z2qy9s6p860f18ns1f1f00vi54dm4c5";
  };

  buildInputs = [];
  phaseNames = ["doUnpack" "installFonts"];

  name = "linux-libertine-2.7";
  meta = {
    description = "Linux Libertine Fonts";
    homepage = http://linuxlibertine.sf.net;
  };
}

