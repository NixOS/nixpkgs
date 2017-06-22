{ stdenv, fetchFromGitHub }:

let optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "lmdb-${version}";
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "LMDB";
    repo = "lmdb";
    rev = "LMDB_${version}";
    sha256 = "026a6himvg3y4ssnccdbgr3c2pq3w2d47nayn05v512875z4f2w3";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/libraries/liblmdb";

  outputs = [ "bin" "out" "dev" ];

  makeFlags = [ "prefix=$(out)" "CC=cc" ];

  doCheck = true;
  checkPhase = "make test";

  postInstall = ''
    moveToOutput bin "$bin"
    moveToOutput "lib/*.a" REMOVE # until someone needs it
  ''

    # fix bogus library name
    + stdenv.lib.optionalString stdenv.isDarwin ''
    mv "$out"/lib/liblmdb.{so,dylib}
    ''

    # add lmdb.pc (dynamic only)
    + ''
    mkdir -p "$dev/lib/pkgconfig"
    cat > "$dev/lib/pkgconfig/lmdb.pc" <<EOF
    Name: lmdb
    Description: ${meta.description}
    Version: ${version}

    Cflags: -I$dev/include
    Libs: -L$out/lib -llmdb
    EOF
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
    maintainers = with maintainers; [ jb55 vcunat ];
    license = licenses.openldap;
    platforms = platforms.all;
  };
}
