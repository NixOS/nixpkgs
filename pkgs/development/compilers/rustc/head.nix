{ stdenv, fetchurl, fetchgit, which, file, perl, curl, python27, makeWrapper
, tzdata, git, valgrind, procps, coreutils
}:

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

with ((import ./common.nix) {inherit stdenv; version = "0.13.0-pre-2604-g2f3cff6";});

let snapshot = if stdenv.system == "i686-linux"
      then "3daf531aed03f5769402f2fef852377e2838db98"
      else if stdenv.system == "x86_64-linux"
      then "4f3c8b092dd4fe159d6f25a217cf62e0e899b365"
      else if stdenv.system == "i686-darwin"
      then "2a3e647b9c400505bd49cfe56091e866c83574ca"
      else if stdenv.system == "x86_64-darwin"
      then "5e730efc34d79a33f464a87686c10eace0760a2e"
      else abort "no-snapshot for platform ${stdenv.system}";
    snapshotDate = "2014-12-20";
    snapshotRev = "8443b09";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2";

in stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchgit {
    url = https://github.com/rust-lang/rust;
    rev = "2f3cff6956d56048ef7afb6d33e17cbdb2dcf038";
    sha256 = "113y74sd1gr7f0xs1lsgjw3jkvhz8s4dxx34r9cxlw5vjr7fp066";
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
  patches = [ ./hardcode_paths.HEAD.patch ./local_stage0.HEAD.patch ]
            ++ stdenv.lib.optional stdenv.needsPax ./grsec.HEAD.patch;

  postPatch = ''
    substituteInPlace src/librustc_trans/back/link.rs \
      --subst-var-by "ccPath" "${stdenv.cc}/bin/cc"
    substituteInPlace src/librustc_back/archive.rs \
      --subst-var-by "arPath" "${stdenv.cc.binutils}/bin/ar"

    substituteInPlace src/rust-installer/gen-install-script.sh \
      --replace /bin/echo "${coreutils}/bin/echo"
  '';

  buildInputs = [ which file perl curl python27 makeWrapper git valgrind procps ];

  enableParallelBuilding = false; # disabled due to rust-lang/rust#16305

  preCheck = "export TZDIR=${tzdata}/share/zoneinfo";

  doCheck = true;

  postInstall = ''
      # Install documentation
      cp -r doc "$out/share/doc"
  '';
}
