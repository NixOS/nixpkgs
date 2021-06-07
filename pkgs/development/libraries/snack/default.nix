# alsaLib vorbis-tools python can be made optional

{ lib, stdenv, fetchurl, python, tcl, tk, vorbis-tools, pkg-config, xlibsWrapper }:

stdenv.mkDerivation {
  name = "snack-2.2.10";

  src = fetchurl {
    url = "https://www.speech.kth.se/snack/dist/snack2.2.10.tar.gz";
    sha256 = "07p89jv9qnjqkszws9sssq93ayvwpdnkcxrvyicbm4mb8x2pdzjb";
  };

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" ];

  postUnpack = ''sourceRoot="$sourceRoot/unix"'';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ python tcl tk vorbis-tools xlibsWrapper ];

  hardeningDisable = [ "format" ];

  postInstall = "aoeu";

  installPhase = ''
    mkdir -p $out
    make install DESTDIR="$out"
  '';

  meta = {
    description = "The Snack Sound Toolkit (Tcl)";
    homepage = "http://www.speech.kth.se/snack/";
    license = lib.licenses.gpl2;
    broken = true;
  };
}
