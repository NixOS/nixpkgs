{ stdenv, mkDerivation, fetchurl, cmake, pkgconfig, alsaLib
, libjack2, libsndfile, fftw, curl, gcc
, libXt, qtbase, qttools, qtwebengine
, readline, qtwebsockets, useSCEL ? false, emacs
}:

let optional = stdenv.lib.optional;
in

mkDerivation rec {
  pname = "supercollider";
  version = "3.10.2";


  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source-linux.tar.bz2";
    sha256 = "0ynz1ydcpsd5h57h1n4a7avm6p1cif5a8rkmz4qpr46pr8z9p6iq";
  };

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DSC_WII=OFF"
    "-DSC_EL=${if useSCEL then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  buildInputs = [
    gcc libjack2 libsndfile fftw curl libXt qtbase qtwebengine qtwebsockets readline ]
      ++ optional (!stdenv.isDarwin) alsaLib
      ++ optional useSCEL emacs;

  meta = with stdenv.lib; {
    description = "Programming language for real time audio synthesis";
    homepage = http://supercollider.sourceforge.net/;
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.gpl3;
    platforms = [ "x686-linux" "x86_64-linux" ];
  };
}
