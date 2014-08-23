args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.attrByPath ["version"] "0.12" args;
  buildInputs = with args; [
    
  ];
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/opende/ode-${version}.tar.bz2";
    sha256 = "0l63ymlkgfp5cb0ggqwm386lxmc3al21nb7a07dd49f789d33ib5";
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
