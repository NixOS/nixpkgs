{stdenv, fetchurl, fetchgit, which, file, perl, curl, python27, makeWrapper}:

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

with ((import ./common.nix) {inherit stdenv; version = "0.12.0-pre-79a5448f4"; });

let snapshot = if stdenv.system == "i686-linux"
      then "6f5464c9ab191d93bfea0894ca7c6f90c3506f2b"
      else if stdenv.system == "x86_64-linux"
      then "72c92895fa9a1dba7880073f2b2b5d0e3e1a2ab6"
      else if stdenv.system == "i686-darwin"
      then "545fc45a0071142714639c6be377e6d308c3a4e1"
      else if stdenv.system == "x86_64-darwin"
      then "8b44fbbbd1ba519d2e83d0d5ce1f6053d3cab8c6"
      else abort "no-snapshot for platform ${stdenv.system}";
    snapshotDate = "2014-09-10";
    snapshotRev = "6faa4f3";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2";

in stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchgit {
    url = https://github.com/rust-lang/rust;
    rev = "79a5448f41dcc6ab52663105a6b02fc5af4c503e";
    sha256 = "0v2ahwgb1ls3g4ch6005azjmfh8bs0v0nbmmfpn53zgiiywad2ji";
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
