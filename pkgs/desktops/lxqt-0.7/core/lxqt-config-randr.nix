{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libX11
, xrandr
}:

stdenv.mkDerivation rec {
  basename = "lxqt-config-randr";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "7a8fcd1ff7e15bdc0a8166d299c7eddb165b5c55";
    sha256 = "3b5591845b56fafa360add998f2e09536691124f6ca182393a637a31e706ad54";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    libX11 xrandr
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Simple monitor configuration";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
