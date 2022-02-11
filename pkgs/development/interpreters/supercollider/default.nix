{ lib, stdenv, mkDerivation, fetchurl, cmake, pkg-config, alsa-lib
, libjack2, libsndfile, fftw, curl, gcc
, libXt, qtbase, qttools, qtwebengine
, readline, qtwebsockets, useSCEL ? false, emacs
}:

let
  inherit (lib) optional;
in
mkDerivation rec {
  pname = "supercollider";
  version = "3.12.2";

  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source.tar.bz2";
    sha256 = "sha256-1QYorCgSwBK+SVAm4k7HZirr1j+znPmVicFmJdvO3g4=";
  };

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DSC_WII=OFF"
    "-DSC_EL=${if useSCEL then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [ cmake pkg-config qttools ];

  buildInputs = [
    gcc libjack2 libsndfile fftw curl libXt qtbase qtwebengine qtwebsockets readline ]
      ++ optional (!stdenv.isDarwin) alsa-lib
      ++ optional useSCEL emacs;

  meta = with lib; {
    description = "Programming language for real time audio synthesis";
    homepage = "https://supercollider.github.io";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
