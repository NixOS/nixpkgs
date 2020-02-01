{ stdenv, mkDerivation, fetchurl, cmake, pkgconfig, alsaLib
, libjack2, libsndfile, fftw, curl, gcc
, libXt, qtbase, qttools, qtwebengine
, readline, qtwebsockets, useSCEL ? false, emacs
}:

let optional = stdenv.lib.optional;
in

mkDerivation rec {
  pname = "supercollider";
  version = "3.10.4";


  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source.tar.bz2";
    sha256 = "168r0c0axgajsdzc1caklydrnagy4flv7i7jcyqwpc9agsqy0nnf";
  };

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DSC_WII=OFF"
    "-DSC_EL=${if useSCEL then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  enableParallelBuilding = true;

  buildInputs = [
    gcc libjack2 libsndfile fftw curl libXt qtbase qtwebengine qtwebsockets readline ]
      ++ optional (!stdenv.isDarwin) alsaLib
      ++ optional useSCEL emacs;

  meta = with stdenv.lib; {
    description = "Programming language for real time audio synthesis";
    homepage = "https://supercollider.github.io";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.gpl3;
    platforms = [ "x686-linux" "x86_64-linux" ];
  };
}
