# alsa-lib vorbis-tools python2 can be made optional

{ lib, stdenv, fetchurl, python2, tcl, tk, vorbis-tools, pkg-config, xlibsWrapper }:

stdenv.mkDerivation rec {
  pname = "snack";
  version = "2.2.10";

  src = fetchurl {
    url = "https://www.speech.kth.se/snack/dist/${pname}${version}.tar.gz";
    sha256 = "07p89jv9qnjqkszws9sssq93ayvwpdnkcxrvyicbm4mb8x2pdzjb";
  };

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" ];

  postUnpack = ''sourceRoot="$sourceRoot/unix"'';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ python2 tcl tk vorbis-tools xlibsWrapper ];

  hardeningDisable = [ "format" ];

  postInstall = "aoeu";

  installPhase = ''
    mkdir -p $out
    make install DESTDIR="$out"
  '';

  meta = {
    description = "The Snack Sound Toolkit (Tcl)";
    homepage = "https://www.speech.kth.se/snack/";
    license = lib.licenses.gpl2;
    broken = true;
  };
}
