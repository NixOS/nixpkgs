{ fetchurl, stdenv, zlib, openssl, libuuid, file }:

stdenv.mkDerivation rec {
  name = "libewf-20100226";
  src = fetchurl {
    url = "mirror://sourceforge/libewf/${name}.tar.gz";
    sha256 = "aedd2a6b3df6525ff535ab95cd569ebb361a4022eb4163390f26257913c2941a";
  };

  preConfigure = ''sed -e 's@/usr/bin/file@file@g' -i configure'';

  buildInputs = [ zlib openssl libuuid ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = http://sourceforge.net/projects/libewf/;
    license = "free";
  };
}
