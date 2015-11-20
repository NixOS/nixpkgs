{ stdenv, fetchzip }:

let optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "lmdb-${version}";
  version = "0.9.16";

  src = fetchzip {
    url = "https://github.com/LMDB/lmdb/archive/LMDB_${version}.tar.gz";
    sha256 = "1lkmngscijwiz09gdkqygdp87x55vp8gb4fh4vq7s34k4jv0327l";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/libraries/liblmdb";

  makeFlags = ["prefix=$(out)"]
              ++ optional stdenv.cc.isClang "CC=clang";

  doCheck = true;
  checkPhase = "make test";

  preInstall = ''
    mkdir -p $out/{man/man1,bin,lib,include}
  '';

  meta = with stdenv.lib; {
    description = "Lightning memory-mapped database";
    longDescription = ''
      LMDB is an ultra-fast, ultra-compact key-value embedded data store
      developed by Symas for the OpenLDAP Project. It uses memory-mapped files,
      so it has the read performance of a pure in-memory database while still
      offering the persistence of standard disk-based databases, and is only
      limited to the size of the virtual address space.
    '';
    homepage = http://symas.com/mdb/;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.openldap;
    platforms = platforms.all;
  };
}
