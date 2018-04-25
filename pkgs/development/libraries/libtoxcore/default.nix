{ stdenv, fetchFromGitHub, cmake, libsodium, ncurses, libopus, libmsgpack
, libvpx, check, libconfig, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libtoxcore-${version}";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner  = "TokTok";
    repo   = "c-toxcore";
    rev    = "v${version}";
    sha256 = "1fya5gfiwlpk6fxhalv95n945ymvp2iidiyksrjw1xw95fzsp1ij";
  };

  cmakeFlags = [
    "-DBUILD_NTOX=ON"
    "-DDHT_BOOTSTRAP=ON"
    "-DBOOTSTRAP_DAEMON=ON"
  ];

  buildInputs = [
    libsodium libmsgpack ncurses libconfig
  ] ++ stdenv.lib.optionals (!stdenv.isArm) [
    libopus
    libvpx
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  doCheck = false; # hangs, tries to access the net?

  # for some reason the tests are not running - it says "No tests found!!"
  checkInputs = [ check ];
  checkPhase = "ctest";

  meta = with stdenv.lib; {
    description = "P2P FOSS instant messaging application aimed to replace Skype";
    homepage = https://tox.chat;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
