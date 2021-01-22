{ fetchurl, lib, stdenv, zlib, openssl, libuuid, pkg-config }:

stdenv.mkDerivation rec {
  version = "20201210";
  pname = "libewf";

  src = fetchurl {
    url = "https://github.com/libyal/libewf/releases/download/${version}/libewf-experimental-${version}.tar.gz";
    sha256 = "sha256-dI1We2bsBRDcyqd6HLC7eBE99dpzSkhHtNgt0ZE4aDc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib openssl libuuid ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.raskin ] ;
    platforms = lib.platforms.unix;
    inherit version;
  };
}
