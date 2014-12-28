{stdenv, fetchurl, which, file, perl, curl, python27, makeWrapper}:

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

with ((import ./common.nix) {inherit stdenv; version = "0.12.0"; });

let snapshot = if stdenv.system == "i686-linux"
      then "555aca74f9a268f80cab2df1147dc6406403e9e4"
      else if stdenv.system == "x86_64-linux"
      then "6a43c2f6c8ba2cbbcb9da1f7b58f748aef99f431"
      else if stdenv.system == "i686-darwin"
      then "331bd7ef519cbb424188c546273e8c7d738f0894"
      else if stdenv.system == "x86_64-darwin"
      then "2c83a79a9febfe1d326acb17c3af76ba053c6ca9"
      else abort "no-snapshot for platform ${stdenv.system}";
    snapshotDate = "2014-10-04";
    snapshotRev = "749ff5e";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2";

in stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchurl {
    url = http://static.rust-lang.org/dist/rust-0.12.0.tar.gz;
    sha256 = "1dv9wxh41230zknbwj34zgjnh1kgvvy6k12kbiy9bnch9nr6cgl8";
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
      patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.cc.dynamicLinker}" \
               --set-rpath "${stdenv.cc.gcc}/lib/:${stdenv.cc.gcc}/lib64/" \
               "$out/bin/rustc"
    '' else "");
  };

  configureFlags = [ "--enable-local-rust" "--local-rust-root=$snapshot" ]
                ++ stdenv.lib.optional (stdenv.cc ? clang) "--enable-clang";

  # The compiler requires cc, so we patch the source to tell it where to find it
  patches = [ ./hardcode_paths.patch ./local_stage0.patch ];
  postPatch = ''
    substituteInPlace src/librustc/back/link.rs \
      --subst-var-by "ccPath" "${stdenv.cc}/bin/cc"
    substituteInPlace src/librustc_back/archive.rs \
      --subst-var-by "arPath" "${stdenv.cc.binutils}/bin/ar"
  '';

  buildInputs = [ which file perl curl python27 makeWrapper ];
  enableParallelBuilding = true;
}
