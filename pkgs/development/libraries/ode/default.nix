args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.attrByPath ["version"] "0.11.1" args; 
  buildInputs = with args; [
    
  ];
in
rec {
  src = fetchurl {
    url = "http://downloads.sourceforge.net/opende/ode-${version}.tar.bz2";
    sha256 = "1883gbsnn7zldrpwfdh6kwj20g627n5bspz3yb2z6lrxdal88y47";
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
