{ lib, stdenv, fetchurl, pkgconfig
, wayland, fontconfig, pixman, freetype, libdrm
}:

stdenv.mkDerivation rec {
  name = "wld-${version}";
  version = "git-2015-09-01";
  repo = "https://github.com/michaelforney/wld";
  rev = "efe0a1ed1856a2e4a1893ed0f2d7dde43b5627f0";

  src = fetchurl {
    url = "${repo}/archive/${rev}.tar.gz";
    sha256 = "09388f7828e18c75e7b8d41454903886a725d7a868f60e66c128bd7d2e953ee1";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ wayland fontconfig pixman freetype libdrm ];

  makeFlags = "PREFIX=$(out)";
  installPhase = "PREFIX=$out make install";

  meta = {
    description = "A primitive drawing library targeted at Wayland";
    homepage    = repo;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
