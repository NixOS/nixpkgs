args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.getAttr ["version"] "0.10.1" args; 
  buildInputs = with args; [
    
  ];
in
rec {
  src = fetchurl {
    url = "http://downloads.sourceforge.net/opende/ode-${version}.tar.bz2";
    sha256 = "0bm7kmm7qvrbk40pgaszqr66pjfvnln8vjzdmcdl2h1dxi3b4dln";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "ode-" + version;
  meta = {
    description = "Open Dynamics Engine";
  };
}
