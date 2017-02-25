{ stdenv, fetchFromGitHub, cmake, libsodium, ncurses, libopus, libmsgpack
, libvpx, check, libconfig, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libtoxcore-${version}";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner  = "TokTok";
    repo   = "c-toxcore";
    rev    = "v${version}";
    sha256 = "0a00gjar6ibaqa2cm81867nk7chsd141v360268v7ym2mxwa0ya6";
  };

  cmakeFlags = [
    "-DBUILD_NTOX=ON"
    "-DDHT_BOOTSTRAP=ON"
    "-DBOOTSTRAP_DAEMON=ON"
  ];

  buildInputs = [
    libsodium libmsgpack ncurses
  ] ++ stdenv.lib.optionals (!stdenv.isArm) [
    libopus
    libvpx
  ];
  nativeBuildInputs = [ cmake pkgconfig ];
  checkInputs = [ check ];

  checkPhase = "ctest";

  # for some reason the tests are not running - it says "No tests found!!"
  doCheck = true;

  meta = with stdenv.lib; {
    description = "P2P FOSS instant messaging application aimed to replace Skype with crypto";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
