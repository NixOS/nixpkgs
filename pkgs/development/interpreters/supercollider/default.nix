{ stdenv, fetchurl, cmake, pkgconfig
, libjack2, libsndfile, fftw, curl, gcc
, libXt, qtbase, qttools, qtwebkit, readline
, useSCEL ? false, emacs
}:

let optional = stdenv.lib.optional;
in

stdenv.mkDerivation rec {
  name = "supercollider-${version}";
  version = "3.8.0";


  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source-linux.tar.bz2";
    sha256 = "053b2xc2x1sczvlb41w6iciqlwy0zyfiv3jrynx4f8jgd6mizsm6";
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
