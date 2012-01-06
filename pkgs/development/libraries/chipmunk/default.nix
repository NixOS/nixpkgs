args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  fullDepEntry = args.fullDepEntry;

  version = lib.attrByPath ["version"] "6.0.3" args; 
  majorVersion = lib.attrByPath ["majorVersion"] "6" args; 
  buildInputs = with args; [
    cmake freeglut mesa 
    libX11 xproto inputproto libXi libXmu
  ];
in
rec {
  src = fetchurl {
    url = "http://files.slembcke.net/chipmunk/release/Chipmunk-${majorVersion}.x/Chipmunk-${version}.tgz";
    sha256 = "c6f550454bc1c63a2a63e0ff8febecb4781a528ab6d6b657a17933a6f567541a";
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
    cp Demo/chipmunk_demos $out/bin
  '') ["doMakeInstall" "defEnsureDir"];
      
  name = "chipmunk-" + version;
  meta = {
    description = "Chipmunk 2D physics engine";
  };
}
