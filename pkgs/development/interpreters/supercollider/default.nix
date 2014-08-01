{ stdenv, fetchurl, cmake, pkgconfig
, jack2, libsndfile, fftw, curl
, libXt, qt, readline
, useSCEL ? false, emacs
}:
  
let optional = stdenv.lib.optional; in

stdenv.mkDerivation rec {  
  name = "supercollider-3.6.6";

  meta = {
    description = "Programming language for real time audio synthesis";
    homepage = "http://supercollider.sourceforge.net/";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/supercollider/Source/3.6/SuperCollider-3.6.6-Source.tar.bz2";
    sha256 = "11khrv6jchs0vv0lv43am8lp0x1rr3h6l2xj9dmwrxcpdayfbalr";
  };

  # QGtkStyle unavailable
  patchPhase = ''
    substituteInPlace editors/sc-ide/widgets/code_editor/autocompleter.cpp \
      --replace Q_WS_X11 Q_GTK_STYLE
  '';

  cmakeFlags = ''
    -DSC_WII=OFF
    -DSC_EL=${if useSCEL then "ON" else "OFF"} 
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ 
    jack2 libsndfile fftw curl libXt qt readline ]
    ++ optional useSCEL emacs;
}
