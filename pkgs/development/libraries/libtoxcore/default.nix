{ lib, stdenv, fetchFromGitHub, cmake, libsodium, ncurses, libopus, msgpack
, libvpx, check, libconfig, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libtoxcore";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner  = "TokTok";
    repo   = "c-toxcore";
    rev    = "v${version}";
    sha256 = "sha256-SOI6QKOSt/EK9JDrSaV6CrD5sx8aYb5ZL3StYq8u/Dg=";
  };

  cmakeFlags = [
    "-DBUILD_NTOX=ON"
    "-DDHT_BOOTSTRAP=ON"
    "-DBOOTSTRAP_DAEMON=ON"
  ];

  buildInputs = [
    libsodium msgpack ncurses libconfig
  ] ++ lib.optionals (!stdenv.isAarch32) [
    libopus libvpx
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  doCheck = false; # hangs, tries to access the net?
  checkInputs = [ check ];

  postFixup =''
    sed -i $out/lib/pkgconfig/*.pc \
      -e "s|^libdir=.*|libdir=$out/lib|" \
      -e "s|^includedir=.*|includedir=$out/include|"
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "P2P FOSS instant messaging application aimed to replace Skype";
    homepage = "https://tox.chat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg ehmry ];
    platforms = platforms.all;
  };
}
