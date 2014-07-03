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
  snapshot = "84339ea0f796ae468ef86797ef4587274bec19ea";
  target = "i686-unknown-linux-gnu";
} else if stdenv.system == "x86_64-linux" then {
  platform = "linux-x86_64";
  snapshot = "bd8a6bc1f28845b7f4b768f6bfa06e7fbdcfcaae";
  target = "x86_64-unknown-linux-gnu";
} else if stdenv.system == "x86_64-darwin" then {
  platform = "macos-x86_64";
  snapshot = "4a8c2e1b7634d73406bac32a1a97893ec3ed818d";
} else {};
let snapshotDate = "2014-06-21";
    snapshotRev = "db9af1d";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2"; in
stdenv.mkDerivation {
  name = "rust-0.11.0";

  src = fetchurl {
    url = http://static.rust-lang.org/dist/rust-0.11.0.tar.gz;
    sha256 = "1fhi8iiyyj5j48fpnp93sfv781z1dm0xy94h534vh4mz91jf7cyi";
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

  meta = with stdenv.lib; {
    homepage = http://www.rust-lang.org/;
    description = "A safe, concurrent, practical language";
    maintainers = with maintainers; [ madjar cstrahan ];
    license = map (builtins.getAttr "shortName") [ licenses.mit licenses.asl20 ];
    # platforms as per http://static.rust-lang.org/doc/master/tutorial.html#getting-started
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}

