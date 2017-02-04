{ stdenv, fetchFromGitHub }:

let optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "lmdb-${version}";
  version = "0.9.19";

  src = fetchFromGitHub {
    owner = "LMDB";
    repo = "lmdb";
    rev = "LMDB_${version}";
    sha256 = "04qx803jdmhkcam748fn0az3cyzvj91lw28kcvwfyq0al7pmjkfs";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/libraries/liblmdb";

  makeFlags = ["prefix=$(out)"]
              ++ optional stdenv.cc.isClang "CC=clang";

  doCheck = true;
  checkPhase = "make test";

  preInstall = ''
    mkdir -p $out/{bin,lib,include}
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
