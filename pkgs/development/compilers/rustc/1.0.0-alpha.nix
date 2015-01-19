{stdenv, fetchurl, which, file, perl, curl, python27, makeWrapper
, tzdata, git, valgrind, procps, coreutils
}:

assert !stdenv.isFreeBSD;

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

with ((import ./common.nix) {inherit stdenv; version = "1.0.0-alpha"; });

let snapshotHash = if stdenv.system == "i686-linux"
      then "d8b73fc9aa3ad72ce1408a41e35d78dba10eb4d4"
      else if stdenv.system == "x86_64-linux"
      then "697880d3640e981bbbf23284363e8e9a158b588d"
      else if stdenv.system == "i686-darwin"
      then "a73b1fc03e8cac747aab0aa186292bb4332a7a98"
      else if stdenv.system == "x86_64-darwin"
      then "e4ae2670ea4ba5c2e5b4245409c9cab45c9eeb5b"
      else abort "no-snapshot for platform ${stdenv.system}";
    snapshotDate = "2015-01-07";
    snapshotRev = "9e4e524";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshotHash}.tar.bz2";

in stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchurl {
    url = "http://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
    sha256 = "0p62gx3s087n09d2v3l9iyfx5cmsa1x91n4ysixcb7w3drr8a8is";
  };

  # We need rust to build rust. If we don't provide it, configure will try to download it.
  snapshot = stdenv.mkDerivation {
    name = "rust-stage0";
    src = fetchurl {
      url = "http://static.rust-lang.org/stage0-snapshots/${snapshotName}";
      sha1 = snapshotHash;
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
  patches = [ ./hardcode_paths.patch ./local_stage0.patch ]
            ++ stdenv.lib.optional stdenv.needsPax ./grsec.patch;

  postPatch = ''
    substituteInPlace src/librustc_trans/back/link.rs \
      --subst-var-by "ccPath" "${stdenv.cc}/bin/cc"
    substituteInPlace src/librustc_back/archive.rs \
      --subst-var-by "arPath" "${stdenv.cc.binutils}/bin/ar"

    substituteInPlace src/rust-installer/gen-install-script.sh \
      --replace /bin/echo "${coreutils}/bin/echo"
    substituteInPlace src/rust-installer/gen-installer.sh \
      --replace /bin/echo "${coreutils}/bin/echo"
  '';

  buildInputs = [ which file perl curl python27 makeWrapper git valgrind procps ];

  enableParallelBuilding = false; # disabled due to rust-lang/rust#16305

  preCheck = "export TZDIR=${tzdata}/share/zoneinfo";

  doCheck = true;
}
