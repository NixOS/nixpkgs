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

  phaseNames = ["doPatch" "fixX86Def" "killUsr" "doMakeInstall"];
  patches = [./constants.patch];
  makeFlags = [
    "DESTDIR=$out"
    ];
  fixX86Def = a.fullDepEntry (''
    sed -i lrmi.c -e 's@defined(__i386__)@(defined(__i386__) || defined(__x86_64__))@'
  '') ["doUnpack" "minInit"];
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
