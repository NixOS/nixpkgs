{ stdenv, fetchurl, fetchgit, which, file, perl, curl, python27, makeWrapper
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


NOTE : some derivation depend on rust. When updating this, please make
sure those derivations still compile. (racer, for example).

*/

let shortVersion = "0.13-dev";
    rev = "6539cb417f4a7c2d9d1afce44c196578d2b67f38";
    revShort = builtins.substring 0 7 rev;
in

with ((import ./common.nix) {inherit stdenv; version = "${shortVersion}-g${revShort}"; });

let snapshotHash = if stdenv.system == "i686-linux"
      then "b880b98d832c9a049b8ef6a50df50061e363de5a"
      else if stdenv.system == "x86_64-linux"
      then "82a09c162474b69d2d1e4e8399086f3f0f4e31c3"
      else if stdenv.system == "i686-darwin"
      then "569055bb10d96ab25f78ecf2c80ffbccd5e69b8d"
      else if stdenv.system == "x86_64-darwin"
      then "cff1f9ebd63dae6890359b7d353bd9486d8ecdfc"
      else abort "no snapshot for platform ${stdenv.system}";
    snapshotDate = "2015-01-04";
    snapshotRev = "b2085d9";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshotHash}.tar.bz2";
in

stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchgit {
    url = https://github.com/rust-lang/rust;
    inherit rev;
    sha256 = "14nc42j46hvlqms77245vil2wplmvci3ramxrmjyjqg0bql1w28m";
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
  patches = [ ./hardcode_paths.HEAD.patch ./local_stage0.HEAD.patch ]
            ++ stdenv.lib.optional stdenv.needsPax ./grsec.HEAD.patch;

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
