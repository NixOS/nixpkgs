{ lib, stdenv, fetchurl, fetchpatch, readline }:

stdenv.mkDerivation rec {
  pname = "mujs";
  version = "1.3.2";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.xz";
    sha256 = "sha256-SIZZP8aIsM3M0x5ey+Wv560b7iOqaeZnuHGv1d/GQMM=";
  };

  patches = lib.optionals stdenv.isDarwin [
    (fetchpatch {
      # ld: library not found for -l:libmujs.a
      name = "darwin-failures.patch";
      url = "https://git.ghostscript.com/?p=mujs.git;a=patch;h=d592c785c0b2f9fea982ac3fe7b88fdd7c4817fc";
      sha256 = "sha256-/57A7S65LWZFyQIGe+LtqDMu85K1N/hbztXB+/nCDJk=";
      revert = true;
    })
  ];

  buildInputs = [ readline ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://mujs.com/";
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.isc;
  };
}
