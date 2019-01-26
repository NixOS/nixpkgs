{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lmdb-${version}";
  version = "0.9.23";

  src = fetchFromGitHub {
    owner = "LMDB";
    repo = "lmdb";
    rev = "LMDB_${version}";
    sha256 = "0ag7l5180ajvm73y59m7sn3p52xm8m972d08cshxhpwgwa4v35k6";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/libraries/liblmdb";

  patches = [ ./hardcoded-compiler.patch ];
  patchFlags = "-p3";

  outputs = [ "bin" "out" "dev" ];

  makeFlags = [ "prefix=$(out)" "CC=cc" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/liblmdb.so";

  doCheck = true;
  checkPhase = "make test";

  postInstall = ''
    moveToOutput bin "$bin"
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
