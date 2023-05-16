{ lib, stdenv, fetchFromGitLab, windows }:

stdenv.mkDerivation rec {
  pname = "lmdb";
<<<<<<< HEAD
  version = "0.9.31";
=======
  version = "0.9.30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "git.openldap.org";
    owner = "openldap";
    repo = "openldap";
    rev = "LMDB_${version}";
<<<<<<< HEAD
    sha256 = "sha256-SBbo7MX3NST+OFPDtQshevIYrIsZD9bOkSsH91inMBw=";
=======
    sha256 = "sha256-zLa9BtSPzujHAIZKDl69lTo72cI3m/GZejFw5v8bFsg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

    # Expected by Rust libraries.
    ln -s lmdb.pc "$dev/lib/pkgconfig/liblmdb.pc"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
