{ lib
, stdenv
, fetchurl
, fetchpatch
, SDL
, autoreconfHook
, autoconf-archive
, glib
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libvisual";
  version = "0.4.2";

  src = fetchurl {
    url = "https://github.com/Libvisual/libvisual/releases/download/libvisual-${version}/libvisual-${version}.tar.gz";
    hash = "sha256-Ywhf2YNcQsk5nqa7E6fr1LFUes51xFlc6Ol1lRK9mYo=";
  };

  outputs = [ "out" "dev" ];
  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook autoconf-archive pkg-config ];
  buildInputs = [ SDL glib ];

  meta = {
    description = "An abstraction library for audio visualisations";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
