a :  
let 
  buildInputs = with a; [
    mpfr m4 binutils emacs gmp
    libX11 xproto inputproto libXi 
    libXext xextproto libXt libXaw libXmu
    zlib which texinfo texLive
  ]; 
in

(
assert a.stdenv ? gcc ;
assert a.stdenv.gcc ? gcc ;
assert a.stdenv.gcc ? libc ;
assert a.stdenv.gcc.gcc != null ;
assert a.stdenv.gcc.libc != null ;

rec {
  src = a.fetchurl {
    sha256 = "1vsicv81ml7d92c87bckgkpvcshi6hzdnj44k0j6zs5mj8pzp8br";
    url="http://gnu.spinellicreations.com/gcl/gcl-2.6.10.tar.gz";
  };

  name = "gcl-2.6.10";
  inherit buildInputs;
  configureFlags = [
    "--enable-ansi"
  ];

  # Upstream bug submitted - http://savannah.gnu.org/bugs/index.php?30371
  # $TMPDIR must have no extension
  setVars = a.noDepEntry ''
    export TMPDIR="''${TMPDIR:-''${TMP:-''${TEMP}}}/tmp-for-gcl"
    mkdir -p "$TMPDIR"
  '';

  preBuild = a.fullDepEntry (''
    sed -re "s@/bin/cat@$(which cat)@g" -i configure */configure
    sed -re "s@if test -d /proc/self @if false @" -i configure
    sed -re 's^([ \t])cpp ^\1cpp -I${a.stdenv.gcc.gcc}/include -I${a.stdenv.gcc.libc}/include ^g' -i makefile
  '') ["minInit" "doUnpack" "addInputs"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doUnpack" "preBuild" 
    "doConfigure" "doMakeInstall"];
}) // {
  meta = {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}
