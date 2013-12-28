args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  fullDepEntry = args.fullDepEntry;

  version = lib.attrByPath ["version"] "6.1.5" args;
  majorVersion = lib.attrByPath ["majorVersion"] "6" args;
  buildInputs = with args; [
    cmake freeglut mesa
    libX11 xproto inputproto libXi libXmu
  ];
in
rec {
  src = fetchurl {
    url = "http://files.slembcke.net/chipmunk/release/Chipmunk-${majorVersion}.x/Chipmunk-${version}.tgz";
    sha256 = "0rhsgl32k6bja2ipzprf7iv3lscbl8h8s9il625rp966jvq6phy7";
  };

  inherit buildInputs;
  configureFlags = [];
  
  /* doConfigure should be specified separately */
  phaseNames = ["genMakefile" "doMakeInstall" "demoInstall"];

  genMakefile = fullDepEntry ''
    cmake -D CMAKE_INSTALL_PREFIX=$out . 
  '' ["minInit" "addInputs" "doUnpack"];

  demoInstall = fullDepEntry(''
    mkdir -p $out/bin
    cp Demo/chipmunk_demos $out/bin
  '') ["doMakeInstall" "defEnsureDir"];
      
  name = "chipmunk-" + version;
  meta = {
    description = "Chipmunk 2D physics engine";
  };
}
