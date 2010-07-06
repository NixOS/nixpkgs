a :  
let 
  buildInputs = with a; [
    mpfr m4 binutils emacs gmp
    libX11 xproto inputproto libXi 
    libXext xextproto libXt libXaw libXmu
    zlib which
  ]; 
in
rec {
  src = a.fetchcvs {
    cvsRoot = ":pserver:anonymous@cvs.sv.gnu.org:/sources/gcl";
    module = "gcl";
    # tag = "Version_2_6_8pre";
    date = "2010-07-01";
    sha256 = "a61d1bf669fd11d13050e8e1ab850a5eecb38126b47c744c3e21646773c4fb4d";
  };

  name = "gcl-2.6.8pre";
  inherit buildInputs;
  configureFlags = [];

  preBuild = a.fullDepEntry (''
    sed -re "s@/bin/cat@$(which cat)@g" -i configure */configure
    sed -re "s@if test -d /proc/self @if false @" -i configure
    sed -re 's^([ \t])cpp ^\1cpp -I${a.stdenv.gcc.gcc}/include -I${a.stdenv.gcc.libc}/include ^g' -i makefile
  '') ["minInit" "doUnpack"];

  fixConfigure = a.doPatchShebangs ".";

  /* doConfigure should be removed if not needed */
  phaseNames = ["doUnpack" "fixConfigure" "preBuild" 
    "doConfigure" "doMakeInstall"];
      
  meta = {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      all;
  };
}
