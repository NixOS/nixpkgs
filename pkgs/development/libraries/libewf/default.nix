{ fetchurl, stdenv, zlib, openssl, libuuid, pkg-config }:

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
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.raskin ] ;
    platforms = stdenv.lib.platforms.unix;
    inherit version;
  };
}
