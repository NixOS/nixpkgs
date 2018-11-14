{ stdenv, fetchurl, fetchpatch, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  name = "libssh-0.7.6";

  src = fetchurl {
    url = "https://www.libssh.org/files/0.7/libssh-0.7.6.tar.xz";
    sha256 = "14hhdpn2hflywsi9d5bz2pfjxqkyi07znjij89cpakr7b4w7sq0x";
  };

  patches = [
    # Fix mysql-workbench compilation
    # https://bugs.mysql.com/bug.php?id=91923
    (fetchpatch {
      name = "include-fix-segfault-in-getissuebanner-add-missing-wrappers-in-libsshpp.patch";
      url = https://git.libssh.org/projects/libssh.git/patch/?id=5ea81166bf885d0fd5d4bb232fc22633f5aaf3c4;
      sha256 = "12q818l3nasqrfrsghxdvjcyya1bfcg0idvsf8xwm5zj7criln0a";
    })
  ];

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
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
