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

with ((import ./common.nix) {inherit stdenv; version = "0.12.0-pre-1336-g394269d";});

let snapshot = if stdenv.system == "i686-linux"
      then "999ba4a0dfb70adca628138a7d5f491023621140"
      else if stdenv.system == "x86_64-linux"
      then "55eaaed3bd6dd5a8d08e99aa4cd618d207f87d8c"
      else if stdenv.system == "i686-darwin"
      then "0581dff21a238343602ec0202a551bac93d21300"
      else if stdenv.system == "x86_64-darwin"
      then "aad290cf3f8ac4aa0661984a9799c78161ea5a72"
      else abort "no-snapshot for platform ${stdenv.system}";
    snapshotDate = "2014-11-18";
    snapshotRev = "9c96a79";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2";

in stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchgit {
    url = https://github.com/rust-lang/rust;
    rev = "394269d16e3752a23ffa273e68f8aaefd2a510c4";
    sha256 = "0zkz5f4gba4glhrf9f7v42qxk638q9ahgf6m0bjh8b7c3x52cv71";
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
}
