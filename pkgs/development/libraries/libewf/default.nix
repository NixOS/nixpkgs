{ fetchurl, fetchpatch, lib, stdenv, zlib, openssl, libuuid, pkg-config, bzip2 }:

stdenv.mkDerivation rec {
  version = "20201230";
  pname = "libewf";

  src = fetchurl {
    url = "https://github.com/libyal/libewf/releases/download/${version}/libewf-experimental-${version}.tar.gz";
    hash = "sha256-10r4jPzsA30nHQzjdg/VkwTG1PwOskwv8Bra34ZPMgc=";
  };

  patches = [
    # fix build with OpenSSL 3.0
    (fetchpatch {
      url = "https://github.com/libyal/libewf/commit/033ea5b4e5f8f1248f74a2ec61fc1be183c6c46b.patch";
      hash = "sha256-R4+NO/91kiZP48SJyVF9oYjKCg1h/9Kh8/0VOEmJXPQ=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib openssl libuuid ]
    ++ lib.optionals stdenv.isDarwin [ bzip2 ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.raskin ] ;
    platforms = lib.platforms.unix;
  };
}
