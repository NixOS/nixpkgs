args : with args; 
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/linuxlibertine/5.0.0/LinLibertineSRC_2011_05_22.tgz;
    sha256 = "1cr0kvvlqrcmaxfl6szfp3m93mcnhmypx33dxmdm3xdxxkab74vg";
  };

  buildInputs = [fontforge];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doUnpack" "generateFontsFromSFD" "installFonts"];
      
  extraFontForgeCommands = ''
    ScaleToEm(1000);
  '';

  doUnpack = fullDepEntry ''
    tar xf ${src}
  '' ["minInit"];

  name = "linux-libertine-5.0.0";
  meta = {
    description = "Linux Libertine Fonts";
    homepage = http://linuxlibertine.sf.net;
  };
}
