{ stdenv, fetchurl, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  name = "libssh-0.7.4";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/210/${name}.tar.xz";
    sha256 = "03bcp9ksqp0s1pmwfmzhcknvkxay5k0mjzzxp3rjlifbng1vxq9r";
  };

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  outputs = [ "out" "dev" ];

  buildInputs = [ zlib openssl libsodium ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "SSH client library";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander urkud ];
    platforms = platforms.all;
  };
}
