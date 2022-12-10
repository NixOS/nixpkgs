{ lib, stdenv, fetchFromGitLab, windows }:

stdenv.mkDerivation rec {
  pname = "lmdb";
  version = "0.9.29";

  src = fetchFromGitLab {
    domain = "git.openldap.org";
    owner = "openldap";
    repo = "openldap";
    rev = "LMDB_${version}";
    sha256 = "19zq5s1amrv1fhw1aszcn2w2xjrk080l6jj5hc9f46yiqf98jjg3";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/libraries/liblmdb";

  patches = [ ./hardcoded-compiler.patch ./bin-ext.patch ];
  patchFlags = [ "-p3" ];

  outputs = [ "bin" "out" "dev" ];

  buildInputs = lib.optional stdenv.hostPlatform.isWindows windows.pthreads;

  makeFlags = [
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ]
    ++ lib.optional stdenv.isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/liblmdb.so"
    ++ lib.optionals stdenv.hostPlatform.isWindows [ "SOEXT=.dll" "BINEXT=.exe" ];

  doCheck = true;
  checkTarget = "test";

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

  meta = with lib; {
    description = "Lightning memory-mapped database";
    longDescription = ''
      LMDB is an ultra-fast, ultra-compact key-value embedded data store
      developed by Symas for the OpenLDAP Project. It uses memory-mapped files,
      so it has the read performance of a pure in-memory database while still
      offering the persistence of standard disk-based databases, and is only
      limited to the size of the virtual address space.
    '';
    homepage = "https://symas.com/lmdb/";
    maintainers = with maintainers; [ jb55 vcunat ];
    license = licenses.openldap;
    platforms = platforms.all;
  };
}
