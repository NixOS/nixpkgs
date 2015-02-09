a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "An event loop library remotely similar to libevent";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = a.lib.platforms.all;
  };
}
