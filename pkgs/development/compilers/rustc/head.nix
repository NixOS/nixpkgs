{stdenv, fetchurl, fetchgit, which, file, perl, curl, python27, makeWrapper}:

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

with ((import ./common.nix) {inherit stdenv; version = "0.12.0-pre-7a25cf3f3"; });

let snapshot = if stdenv.system == "i686-linux"
      then "a5e1bb723020ac35173d49600e76b0935e257a6a"
      else if stdenv.system == "x86_64-linux"
      then "1a2407df17442d93d1c34c916269a345658045d7"
      else if stdenv.system == "i686-darwin"
      then "6648fa88e41ad7c0991a085366e36d56005873ca"
      else if stdenv.system == "x86_64-darwin"
      then "71b2d1dfd0abe1052908dc091e098ed22cf272c6"
      else abort "no-snapshot for platform ${stdenv.system}";
    snapshotDate = "2014-07-17";
    snapshotRev = "9fc8394";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2";

in stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchgit {
    url = https://github.com/rust-lang/rust;
    rev = "7a25cf3f30fa5fae2e868fa910ecc850f5e9ee65";
    sha256 = "1hx8vd4gn5plbdvr0zvdvqyw9x9r2vbmh112h2f5d2xxsf9p7rf1";
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
  patches = [ ./hardcode_paths.patch ./local_stage0.patch ];
  postPatch = ''
    substituteInPlace src/librustc/back/link.rs \
      --subst-var-by "ccPath" "${stdenv.gcc}/bin/cc" \
      --subst-var-by "arPath" "${stdenv.gcc.binutils}/bin/ar"
  '';

  buildInputs = [ which file perl curl python27 makeWrapper ];
  enableParallelBuilding = true;
}
