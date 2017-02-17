{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libjack2, libsndfile, fftw, curl, gcc
, libXt, qt55, readline
, useSCEL ? false, emacs
}:
let optional = stdenv.lib.optional;
in

stdenv.mkDerivation rec {
  name = "supercollider-${version}";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "supercollider";
    repo = "supercollider";
    rev = "Version-${version}";
    sha256 = "11khrv6jchs0vv0lv43am8lp0x1rr3h6l2xj9dmwrxcpdayfbalr";
  };

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = ''
    -DSC_WII=OFF
    -DSC_EL=${if useSCEL then "ON" else "OFF"}
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    gcc libjack2 libsndfile fftw curl libXt qt55.qtwebkit qt55.qttools readline ]
      ++ optional useSCEL emacs;

  meta = {
    description = "Programming language for real time audio synthesis";
    homepage = "http://supercollider.sourceforge.net/";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
