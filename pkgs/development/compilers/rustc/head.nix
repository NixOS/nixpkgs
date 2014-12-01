{ stdenv, fetchurl, fetchgit, which, file, perl, curl, python27, makeWrapper
, tzdata, git, valgrind
}:

assert stdenv.gcc.gcc != null;

/* Rust's build process has a few quirks :

- It requires some patched in llvm that haven't landed upstream, so it
  compiles its own llvm. This might change in the future, so at some
  point we may be able to switch to nix's llvm.

- The Rust compiler is written is Rust, so it requires a bootstrap
  compiler, which is downloaded during the build. To make the build
  pure, we download it ourself before and put it where it is
  expected. Once the language is stable (1.0) , we might want to
  switch it to use nix's packaged rust compiler.

*/

with ((import ./common.nix) {inherit stdenv; version = "0.12.0-pre-1635-g29e928f";});

let snapshot = if stdenv.system == "i686-linux"
      then "c8342e762a1720be939ed7c6a39bdaa27892f66f"
      else if stdenv.system == "x86_64-linux"
      then "7a7fe6f5ed47b9cc66261f880e166c7c8738b73e"
      else if stdenv.system == "i686-darwin"
      then "63e8644512bd5665c14389a83d5af564c7c0b103"
      else if stdenv.system == "x86_64-darwin"
      then "7933ae0e974d1b897806138b7052cb2b4514585f"
      else abort "no-snapshot for platform ${stdenv.system}";
    snapshotDate = "2014-11-21";
    snapshotRev = "c9f6d69";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2";

in stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchgit {
    url = https://github.com/rust-lang/rust;
    rev = "29e928f2ba3501d37660314f6186d0e2ac18b9db";
    sha256 = "1ndg920hnb8r9bblqvmqfflcrppzj68vzbhxf2zghmnx2z7svhxn";
  };

  # We need rust to build rust. If we don't provide it, configure will try to download it.
  snapshot = stdenv.mkDerivation {
    name = "rust-stage0";
    src = fetchurl {
      url = "http://static.rust-lang.org/stage0-snapshots/${snapshotName}";
      sha1 = snapshot;
    };
    dontStrip = true;
    installPhase = ''
      mkdir -p "$out"
      cp -r bin "$out/bin"
    '' + (if stdenv.isLinux then ''
      patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.gcc.dynamicLinker}" \
               --set-rpath "${stdenv.gcc.gcc}/lib/:${stdenv.gcc.gcc}/lib64/" \
               "$out/bin/rustc"
    '' else "");
  };

  configureFlags = [ "--enable-local-rust" "--local-rust-root=$snapshot" ];

  # The compiler requires cc, so we patch the source to tell it where to find it
  patches = [ ./hardcode_paths.HEAD.patch ./local_stage0.HEAD.patch ]
            ++ stdenv.lib.optional stdenv.needsPax ./grsec.HEAD.patch;

  postPatch = ''
    substituteInPlace src/librustc_trans/back/link.rs \
      --subst-var-by "ccPath" "${stdenv.gcc}/bin/cc"
    substituteInPlace src/librustc_back/archive.rs \
      --subst-var-by "arPath" "${stdenv.gcc.binutils}/bin/ar"
  '';

  buildInputs = [ which file perl curl python27 makeWrapper git valgrind ];

  enableParallelBuilding = false; # disabled due to rust-lang/rust#16305

  preCheck = "export TZDIR=${tzdata}/share/zoneinfo";

  doCheck = true;

  postInstall = ''
      # Install documentation
      cp -r doc "$out/share/doc"
  '';
}
