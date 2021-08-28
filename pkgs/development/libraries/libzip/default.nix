{ lib, stdenv
, cmake
, fetchpatch
, fetchurl
, perl
, zlib
, groff
, withBzip2 ? false
, bzip2
, withLZMA ? false
, xz
, withOpenssl ? false
, openssl
}:

stdenv.mkDerivation rec {
  pname = "libzip";
  version = "1.7.3";

  src = fetchurl {
    url = "https://libzip.org/download/${pname}-${version}.tar.gz";
    sha256 = "1k5rihiz7m1ahhjzcbq759hb9crzqkgw78pkxga118y5a32pc8hf";
  };

  # Remove in next release
  patches = [
    (fetchpatch {
      url = "https://github.com/nih-at/libzip/commit/351201419d79b958783c0cfc7c370243165523ac.patch";
      sha256 = "0d93z98ki0yiaza93268cxkl35y1r7ll9f7l8sivx3nfxj2c1n8a";
    })
  ];

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ cmake perl groff ];
  propagatedBuildInputs = [ zlib ];
  buildInputs = lib.optionals withLZMA [ xz ]
    ++ lib.optionals withBzip2 [ bzip2 ]
    ++ lib.optionals withOpenssl [ openssl ];

  preCheck = ''
    # regress/runtest is a generated file
    patchShebangs regress
  '';

  meta = with lib; {
    homepage = "https://libzip.org/";
    description = "A C library for reading, creating and modifying zip archives";
    license = licenses.bsd3;
    platforms = platforms.unix;
    changelog = "https://github.com/nih-at/libzip/blob/v${version}/NEWS.md";
  };
}
