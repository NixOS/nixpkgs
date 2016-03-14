{ lib, stdenv, fetchurl, pkgconfig
, wld, wayland, xwayland, fontconfig, pixman, libdrm, libinput, libevdev, libxkbcommon, libxcb, xcbutilwm
}:

stdenv.mkDerivation rec {
  name = "swc-${version}";
  version = "git-2016-02-09";
  repo = "https://github.com/michaelforney/swc";
  rev = "1da0ef13fddc572accea12439a4471b4d2f64ddd";

  src = fetchurl {
    url = "${repo}/archive/${rev}.tar.gz";
    sha256 = "d1894612d8aa1ce828efb78f1570290f84bba6563e21eb777e08c3c3859b7bbe";
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
