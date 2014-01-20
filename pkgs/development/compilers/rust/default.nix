{stdenv, fetchurl, which, file, perl, curl, python27, makeWrapper}:

let snapshotName = "rust-stage0-2014-01-05-a6d3e57-linux-x86_64-aa8fbbacdb1d8a078f3a3fe3478dcbc506bd4090.tar.bz2"; in
stdenv.mkDerivation {
  name = "rust-0.9";

  src = fetchurl {
    url = http://static.rust-lang.org/dist/rust-0.9.tar.gz;
    sha256 = "1lfmgnn00wrc30nf5lgg52w58ir3xpsnpmzk2v5a35xp8lsir4f0";
  };

  # We need rust to build rust. If we don't provide it, configure will try to download it
  snapshot = fetchurl {
    url = "http://static.rust-lang.org/stage0-snapshots/${snapshotName}";
    sha256 = "17inc23jpznqp0vnskvznm74mm24c1nffhz2bkadhvp2ww0vpjjx";
  };

  # Put the snapshot where it is expected
  postUnpack = ''
    mkdir $sourceRoot/dl
    ln -s $snapshot $sourceRoot/dl/${snapshotName}
  '';

  # Modify the snapshot compiler so that is can be executed
  preBuild = if stdenv.isLinux then ''
    make x86_64-unknown-linux-gnu/stage0/bin/rustc
    patchelf --interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
             --set-rpath ${stdenv.gcc.gcc}/lib/ \
             x86_64-unknown-linux-gnu/stage0/bin/rustc
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

