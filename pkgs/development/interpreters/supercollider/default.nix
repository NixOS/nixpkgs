{ stdenv, fetchurl, cmake, pkgconfig
, libjack2, libsndfile, fftw, curl, gcc
, libXt, qtbase, qttools, qtwebkit, readline
, useSCEL ? false, emacs
}:

let optional = stdenv.lib.optional;
in

stdenv.mkDerivation rec {
  name = "supercollider-${version}";
  version = "3.9.1";


  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source-linux.tar.bz2";
    sha256 = "150fgnjcmb06r3pa3mbsvb4iwnqlimjwdxgbs6p55zz6g8wbln7a";
  };

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = ''
    -DSC_WII=OFF
    -DSC_EL=${if useSCEL then "ON" else "OFF"}
  '';

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  buildInputs = [
    gcc libjack2 libsndfile fftw curl libXt qtbase qtwebkit readline ]
      ++ optional useSCEL emacs;

  meta = {
    description = "Programming language for real time audio synthesis";
    homepage = http://supercollider.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
