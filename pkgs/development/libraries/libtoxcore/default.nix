{ stdenv, fetchFromGitHub, cmake, libsodium, ncurses, libopus, libmsgpack
, libvpx, check, libconfig, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libtoxcore-${version}";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner  = "TokTok";
    repo   = "c-toxcore";
    rev    = "v${version}";
    sha256 = "1d3f7lnlxra2lhih838bvlahxqv50j35g9kfyzspq971sb5z30mv";
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

  enableParallelBuilding = true;

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
