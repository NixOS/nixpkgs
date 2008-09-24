# alsaLib vorbisTools python can be made  optional

args:
args.stdenv.mkDerivation {
  name = "snack-2.2.10";

  src = args.fetchurl {
    url = http://www.speech.kth.se/snack/dist/snack2.2.10.tar.gz;
    sha256 = "07p89jv9qnjqkszws9sssq93ayvwpdnkcxrvyicbm4mb8x2pdzjb";
  };

  configureFlags = "--with-tcl=${args.tcl}/lib --with-tk=${args.tk}/lib";

  postUnpack=''sourceRoot="$sourceRoot/unix"'';

  buildInputs =(with args; [python tcl tk vorbisTools pkgconfig x11]);

  postInstall="aoeu";

  installPhase=''
    ensureDir $out
    make install DESTDIR="$out" 
  '';

  meta = { 
      description = "The Snack Sound Toolkit (Tcl)";
      homepage = "http://www.speech.kth.se/snack/";
      license = "GPL-2";
  };
}
