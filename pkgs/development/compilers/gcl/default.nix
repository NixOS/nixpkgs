a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    gmp mpfr m4 binutils 
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
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      all;
  };
}
