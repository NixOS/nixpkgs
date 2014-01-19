{stdenv, fetchurl, which, file, perl, curl, python27, makeWrapper}:

with if stdenv.system == "i686-linux" then {
  platform = "linux-i386";
  snapshot = "03e60be1f1b90dddd15f3597bc45ec8d9626b35d";
  snapshot_sha = "1v1l082gj7d2d4p53xgsxz2k965jcgqhw4cyxmjxc6yh5fw0idx6";
  target = "i386-unknown-linux-gnu";
} else if stdenv.system == "x86_64-linux" then {
  platform = "linux-x86_64";
  snapshot = "aa8fbbacdb1d8a078f3a3fe3478dcbc506bd4090";
  snapshot_sha = "17inc23jpznqp0vnskvznm74mm24c1nffhz2bkadhvp2ww0vpjjx";
  target = "x86_64-unknown-linux-gnu";
} else if stdenv.system == "x86_64-darwin" then {
  platform = "macos-x86_64";
  snapshot = "ec746585cb20d1f9edffec74f6ff8be6e93a75f7";
  snapshot_sha = "0r8f8x3x8jb1hm40pbgj4i9ll2y5dgjgvj24qg7mp4crbqcqhkd2";
} else {};
let snapshotDate = "2014-01-05";
    snapshotRev = "a6d3e57";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshot}.tar.bz2"; in
stdenv.mkDerivation {
  name = "rust-0.9";

  src = fetchurl {
    url = http://static.rust-lang.org/dist/rust-0.9.tar.gz;
    sha256 = "1lfmgnn00wrc30nf5lgg52w58ir3xpsnpmzk2v5a35xp8lsir4f0";
  };

  # We need rust to build rust. If we don't provide it, configure will try to download it
  snapshot = fetchurl {
    url = "http://static.rust-lang.org/stage0-snapshots/${snapshotName}";
    sha256 = snapshot_sha;
  };

  # Put the snapshot where it is expected
  postUnpack = ''
    mkdir $sourceRoot/dl
    ln -s $snapshot $sourceRoot/dl/${snapshotName}
  '';

  # Modify the snapshot compiler so that is can be executed
  preBuild = if stdenv.isLinux then ''
    make ${target}/stage0/bin/rustc
    patchelf --interpreter ${stdenv.glibc}/lib/${stdenv.gcc.dynamicLinker} \
             --set-rpath ${stdenv.gcc.gcc}/lib/ \
             ${target}/stage0/bin/rustc
  '' else null;

  # rustc requires cc
  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : "${stdenv.gcc}/bin"
    done
  '';

  buildInputs = [ which file perl curl python27 makeWrapper ];
  enableParallelBuilding = true;

  meta = {
    homepage = http://www.rust-lang.org/;
    description = "A safe, concurrent, practical language";
    maintainers = [ stdenv.lib.maintainers.madjar ];
    license = map (builtins.getAttr "shortName") [ stdenv.lib.licenses.mit stdenv.lib.licenses.asl20 ];
    # platforms as per http://static.rust-lang.org/doc/master/tutorial.html#getting-started
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}

