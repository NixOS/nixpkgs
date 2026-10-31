{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  libgsf,
  libxml2,
  bzip2,
}:

stdenv.mkDerivation rec {
  pname = "libwpd";
  version = "0.8.14";

  src = fetchurl {
    url = "mirror://sourceforge/libwpd/libwpd-${version}.tar.gz";
    hash = "sha256-AXRPpjetFqj/rvsap7m0KlbpLwoqGHU/ZyCoWqKJ1Os=";
  };

  patches = [ ./gcc-0.8.patch ];

  buildInputs = [
    glib
    libgsf
    libxml2
  ];

  nativeBuildInputs = [
    pkg-config
    bzip2
  ];

  meta = {
    description = "Library for importing WordPerfect documents";
    homepage = "https://libwpd.sourceforge.net";
    license = with lib.licenses; [
      lgpl21
      mpl20
    ];
    platforms = lib.platforms.unix;
  };
}
