{ stdenv, fetchurl, fetchpatch, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  name = "libssh-0.7.5";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/218/${name}.tar.xz";
    sha256 = "15bh6dm9c50ndddzh3gqcgw7axp3ghrspjpkb1z3dr90vkanvs2l";
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
