args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  fullDepEntry = args.fullDepEntry;

  version = lib.attrByPath ["version"] "4.1.0" args; 
  buildInputs = with args; [
    cmake freeglut mesa 
    libX11 xproto inputproto libXi libXmu
  ];
in
rec {
  src = fetchurl {
    url = "http://files.slembcke.net/chipmunk/release/Chipmunk-${version}.tgz";
    sha256 = "0ry17lf4kdcac91bpavks2cswch3izsmmam0yhczk7rayj9cvqsh";
  };

  inherit buildInputs;
  configureFlags = [];
  
  /* doConfigure should be specified separately */
  phaseNames = ["genMakefile" "doMakeInstall" "demoInstall"];

  genMakefile = fullDepEntry ''
    cmake -D CMAKE_INSTALL_PREFIX=$out . 
  '' ["minInit" "addInputs" "doUnpack"];

  demoInstall = fullDepEntry(''
    ensureDir $out/bin
    cp chipmunk_demos $out/bin
  '') ["doMakeInstall" "defEnsureDir"];
      
  name = "chipmunk-" + version;
  meta = {
    description = "Chipmunk 2D physics engine";
  };
}
