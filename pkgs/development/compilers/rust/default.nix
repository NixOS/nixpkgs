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

with if stdenv.system == "i686-linux" then {
  platform = "linux-i386";
  snapshot = "3bef5684fd0582fbd4ddebd4514182d4f72924f7";
  snapshot_sha = "1c72d65pcgm3z4sly7al09mjvpp8asxbbv7iyzzv5k8f66ny2agy";
  target = "i686-unknown-linux-gnu";
} else if stdenv.system == "x86_64-linux" then {
  platform = "linux-x86_64";
  snapshot = "a7b2af1076d48e4a687a71a21478293e834349bd";
  snapshot_sha = "1c72d65pcgm3z4sly7al09mjvpp8asxbbv7iyzzv5k8f66ny2agy";
  target = "x86_64-unknown-linux-gnu";
} else if stdenv.system == "x86_64-darwin" then {
  platform = "macos-x86_64";
  snapshot = "22b884a3876cb3e40ad942ad68a496b5f239fca5";
  snapshot_sha = "0qabkvyryiwlqhzy1kscff27rx788bv7lh7d8m1hnsv38wqhwqqb";
} else {};
let snapshotDate = "2014-03-28";
    snapshotRev = "b8601a3";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2"; in
stdenv.mkDerivation {
  name = "rust-0.10";

  src = fetchurl {
    url = http://static.rust-lang.org/dist/rust-0.10.tar.gz;
    sha256 = "c72cfbbf03016804a81d7b68e8258ffaf018f8f5a25550ad64571ce6c2642cf9";
  };

  # We need rust to build rust. If we don't provide it, configure will try to download it.
  snapshot = stdenv.mkDerivation {
    name = "rust-stage0";
    src = fetchurl {
      url = "http://static.rust-lang.org/stage0-snapshots/${snapshotName}";
      sha256 = snapshot_sha;
    };
    installPhase = ''
      mkdir -p "$out"
      cp -r bin "$out/bin"
    '' + (if stdenv.isLinux then ''
      patchelf --interpreter ${stdenv.glibc}/lib/${stdenv.gcc.dynamicLinker} \
               --set-rpath ${stdenv.gcc.gcc}/lib/:${stdenv.gcc.gcc}/lib64/ \
               $out/bin/rustc
    '' else "");
  };

  configureFlags = [ "--enable-local-rust" "--local-rust-root=$snapshot" ];

  # The compiler requires cc, so we patch the source to tell it where to find it
  patches = [ ./hardcode_paths.patch ./local_stage0.patch ];
  postPatch = ''
    substituteInPlace src/librustc/back/link.rs \
      --subst-var-by "gccPath" ${stdenv.gcc}/bin/cc \
      --subst-var-by "binutilsPath" ${stdenv.gcc.binutils}/bin/ar
  '';

  buildInputs = [ which file perl curl python27 makeWrapper ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.rust-lang.org/;
    description = "A safe, concurrent, practical language";
    maintainers = with maintainers; [ madjar cstrahan ];
    license = map (builtins.getAttr "shortName") [ licenses.mit licenses.asl20 ];
    # platforms as per http://static.rust-lang.org/doc/master/tutorial.html#getting-started
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}

