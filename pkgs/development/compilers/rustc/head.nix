{ stdenv, fetchurl, fetchgit, which, file, perl, curl, python27, makeWrapper
, tzdata, git
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

with ((import ./common.nix) {inherit stdenv; version = "0.12.0-pre-127-ga0ea210";});

let snapshot = if stdenv.system == "i686-linux"
      then "0644637db852db8a6c603ded0531ccaa60291bd3"
      else if stdenv.system == "x86_64-linux"
      then "656b8c23fbb97794e85973aca725a4b9cd07b29e"
      else if stdenv.system == "i686-darwin"
      then "e4d9709fcfe485fcca00f0aa1fe456e2f164ed96"
      else if stdenv.system == "x86_64-darwin"
      then "6b1aa5a441965da87961be81950e8663eadba377"
      else abort "no-snapshot for platform ${stdenv.system}";
    snapshotDate = "2014-10-10";
    snapshotRev = "78a7676";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2";

in stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchgit {
    url = https://github.com/rust-lang/rust;
    rev = "a0ea210b394aa1b61d341593a3f9098fe5bf7806";
    sha256 = "0flwzj6dywaq9s77ayinshqbz8na2a1jabkr9s7zj74s2ya5096i";
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
  patches = [ ./hardcode_paths.HEAD.patch ./local_stage0.HEAD.patch ];
  postPatch = ''
    substituteInPlace src/librustc/back/link.rs \
      --subst-var-by "ccPath" "${stdenv.gcc}/bin/cc"
    substituteInPlace src/librustc_back/archive.rs \
      --subst-var-by "arPath" "${stdenv.gcc.binutils}/bin/ar"
  '';

  buildInputs = [ which file perl curl python27 makeWrapper git ];

  enableParallelBuilding = false; # disabled due to rust-lang/rust#16305

  preCheck = "export TZDIR=${tzdata}/share/zoneinfo";

  doCheck = true;
}
