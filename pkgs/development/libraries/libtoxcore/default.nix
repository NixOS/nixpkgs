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
  ] ++ stdenv.lib.optionals (!stdenv.isAarch32) [
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
    description = "P2P FOSS instant messaging application aimed to replace Skype";
    homepage = https://tox.chat;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
