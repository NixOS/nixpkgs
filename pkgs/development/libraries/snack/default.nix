# alsaLib vorbis-tools python can be made optional

{ stdenv, fetchurl, python, tcl, tk, vorbis-tools, pkgconfig, xlibsWrapper }:

stdenv.mkDerivation {
  name = "snack-2.2.10";

  src = fetchurl {
    url = https://www.speech.kth.se/snack/dist/snack2.2.10.tar.gz;
    sha256 = "07p89jv9qnjqkszws9sssq93ayvwpdnkcxrvyicbm4mb8x2pdzjb";
  };

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" ];

  postUnpack = ''sourceRoot="$sourceRoot/unix"'';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python tcl tk vorbis-tools xlibsWrapper ];

  hardeningDisable = [ "format" ];

  postInstall = "aoeu";

  installPhase = ''
    mkdir -p $out
    make install DESTDIR="$out" 
  '';

  meta = { 
    description = "The Snack Sound Toolkit (Tcl)";
    homepage = http://www.speech.kth.se/snack/;
    license = stdenv.lib.licenses.gpl2;
    broken = true;
  };
}
