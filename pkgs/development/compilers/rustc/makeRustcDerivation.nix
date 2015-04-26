{ stdenv, fetchurl, fetchgit, which, file, perl, curl, python27, makeWrapper
, tzdata, git, valgrind, procps, coreutils

, shortVersion, isRelease
, srcSha, srcRev ? ""
, snapshotHashLinux686, snapshotHashLinux64
, snapshotHashDarwin686, snapshotHashDarwin64
, snapshotDate, snapshotRev
, configureFlags ? []

, patches
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

assert (if isRelease then srcRev == "" else srcRev != "");

let version = if isRelease then
        "${shortVersion}"
      else
        "${shortVersion}-g${builtins.substring 0 7 srcRev}";

    name = "rustc-${version}";

    platform = if stdenv.system == "i686-linux"
      then "linux-i386"
      else if stdenv.system == "x86_64-linux"
      then "linux-x86_64"
      else if stdenv.system == "i686-darwin"
      then "macos-i386"
      else if stdenv.system == "x86_64-darwin"
      then "macos-x86_64"
      else abort "no snapshot to bootstrap for this platform (missing platform url suffix)";

    target = if stdenv.system == "i686-linux"
      then "i686-unknown-linux-gnu"
      else if stdenv.system == "x86_64-linux"
      then "x86_64-unknown-linux-gnu"
      else if stdenv.system == "i686-darwin"
      then "i686-apple-darwin"
      else if stdenv.system == "x86_64-darwin"
      then "x86_64-apple-darwin"
      else abort "no snapshot to bootstrap for this platform (missing target triple)";

    meta = with stdenv.lib; {
      homepage = http://www.rust-lang.org/;
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ madjar cstrahan wizeman globin ];
      license = map (builtins.getAttr "shortName") [ licenses.mit licenses.asl20 ];
      platforms = platforms.linux;
    };

    snapshotHash = if stdenv.system == "i686-linux"
      then snapshotHashLinux686
      else if stdenv.system == "x86_64-linux"
      then snapshotHashLinux64
      else if stdenv.system == "i686-darwin"
      then snapshotHashDarwin686
      else if stdenv.system == "x86_64-darwin"
      then snapshotHashDarwin64
      else abort "no snapshot for platform ${stdenv.system}";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshotHash}.tar.bz2";
in

stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = if isRelease then
      fetchurl {
        url = "http://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
        sha256 = srcSha;
      }
    else
      fetchgit {
        url = https://github.com/rust-lang/rust;
        rev = srcRev;
        sha256 = srcSha;
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
               --set-rpath "${stdenv.cc.cc}/lib/:${stdenv.cc.cc}/lib64/" \
               "$out/bin/rustc"
    '' else "");
  };

  configureFlags = configureFlags
                ++ [ "--enable-local-rust" "--local-rust-root=$snapshot" ]
                ++ stdenv.lib.optional (stdenv.cc ? clang) "--enable-clang";

  inherit patches;

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

  enableParallelBuilding = true;

  preCheck = "export TZDIR=${tzdata}/share/zoneinfo";

  doCheck = true;
}
