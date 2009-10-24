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

  phaseNames = ["doPatch" "killUsr" "doMakeInstall"];
  patches = [./constants.patch];
  makeFlags = [
    "DESTDIR=$out"
    ];
  killUsr = a.fullDepEntry (''
    sed -e s@/usr@@ -i Makefile
  '') ["doUnpack" "minInit"];
      
  meta = {
    description = "Real-mode x86 code emulator";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux ++ freebsd ++ netbsd;
  };
}
