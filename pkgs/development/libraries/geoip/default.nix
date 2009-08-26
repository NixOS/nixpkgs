a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    zlib
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
  goSrcDir = "cd GeoIP-*/";
      
  meta = {
    description = "Geolocation API";
    maintainers = [
      a.lib.maintainers.raskin
    ];
  };
}
