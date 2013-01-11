args: with args; rec {
  name = "linux-libertine-5.3.0";

  src = fetchurl {
    url = mirror://sf/linuxlibertine/5.3.0/LinLibertineSRC_5.3.0_2012_07_02.tgz;
    sha256 = "0x7cz6hvhpil1rh03rax9zsfzm54bh7r4bbrq8rz673gl9h47v0v";
  };

  buildInputs = [ fontforge ];

  /* doConfigure should be specified separately */
  phaseNames = ["doUnpack" "generateFontsFromSFD" "installFonts"];

  extraFontForgeCommands = ''
    ScaleToEm(1000);
  '';

  doUnpack = lib.fullDepEntry ''
      tar xf ${src}
    '' ["minInit"];

  meta = {
    description = "Linux Libertine Fonts";
    homepage = http://linuxlibertine.sf.net;
  };
}
