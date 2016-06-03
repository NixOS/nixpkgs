{ stdenv, fetchurl }:

let
  platform = if stdenv.system == "i686-linux"
    then "linux-i386"
    else if stdenv.system == "x86_64-linux"
    then "linux-x86_64"
    else if stdenv.system == "i686-darwin"
    then "macos-i386"
    else if stdenv.system == "x86_64-darwin"
    then "macos-x86_64"
    else abort "no snapshot to bootstrap for this platform (missing platform url suffix)";

  /* Rust is bootstrapped from an earlier built version. We need
    to fetch these earlier versions, which vary per platform.
    The shapshot info you want can be found at
    https://github.com/rust-lang/rust/blob/{$shortVersion}/src/snapshots.txt
    with the set you want at the top. Make sure this is the latest snapshot
    for the tagged release and not a snapshot in the current HEAD.
    NOTE: Rust 1.9.0 is the last version that uses snapshots
  */

  snapshotHashLinux686 = "0e0e4448b80d0a12b75485795244bb3857a0a7ef";
  snapshotHashLinux64 = "1273b6b6aed421c9e40c59f366d0df6092ec0397";
  snapshotHashDarwin686 = "9f9c0b4a2db09acbce54b792fb8839a735585565";
  snapshotHashDarwin64 = "52570f6fd915b0210a9be98cfc933148e16a75f8";
  snapshotDate = "2016-03-18";
  snapshotRev = "235d774";

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
  name = "rust-bootstrap";
  src = fetchurl {
    url = "http://static.rust-lang.org/stage0-snapshots/${snapshotName}";
    sha1 = snapshotHash;
  };
  dontStrip = true;
  installPhase = ''
    mkdir -p "$out"
    cp -r bin "$out/bin"
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    patchelf --interpreter "${stdenv.glibc.out}/lib/${stdenv.cc.dynamicLinker}" \
             --set-rpath "${stdenv.cc.cc.lib}/lib/:${stdenv.cc.cc.lib}/lib64/" \
             "$out/bin/rustc"
  '';
}
