{ stdenv, fetchurl, cmake, qt4, perl, shared_mime_info, libvorbis, taglib
, ffmpeg, flac, libsamplerate, libdvdread, lame, libsndfile, libmad, gettext
, kdelibs, kdemultimedia
, automoc4, phonon
}:

stdenv.mkDerivation {
  name = "k3b-2.0.0";
  src = fetchurl {
    url = mirror://sourceforge/k3b/k3b-2.0.0.tar.bz2;
    sha256 = "0jrl4z9k5ml82xd903n4dm68fvmrkyp3k7c17b2494y2gawzqwfz";
  };
  buildInputs = [ cmake qt4 perl shared_mime_info libvorbis taglib 
                  ffmpeg flac libsamplerate libdvdread lame libsndfile
		  libmad gettext stdenv.gcc.libc
                  kdelibs kdemultimedia automoc4 phonon ];
  meta = {
    description = "CD/DVD Burning Application for KDE";
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
