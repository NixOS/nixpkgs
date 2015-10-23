{ lib, stdenv, fetchurl, pkgconfig
, wld, wayland, xwayland, fontconfig, pixman, libdrm, libinput, libevdev, libxkbcommon, libxcb, xcbutilwm
}:

stdenv.mkDerivation rec {
  name = "swc-${version}";
  version = "git-2015-09-05";
  repo = "https://github.com/michaelforney/swc";
  rev = "0dff35ad9b80fc62e6b48417f78c24df6648c9d2";

  src = fetchurl {
    url = "${repo}/archive/${rev}.tar.gz";
    sha256 = "7af5655b5bb5fe59bb8e6643e35f794419850463b1d7f44f29b45ab6aee01ae9";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ wld wayland xwayland fontconfig pixman libdrm libinput libevdev libxkbcommon libxcb xcbutilwm ];

  makeFlags = "PREFIX=$(out)";
  installPhase = "PREFIX=$out make install";

  meta = {
    description = "A library for making a simple Wayland compositor";
    homepage    = repo;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
