{ stdenv, callPackage }:
callPackage ./makeRustcDerivation.nix {
  shortVersion = "1.0.0-alpha.2";
  isRelease = true;
  srcSha = "1j2n34w0hdz7jrl100c9q9hl80l8nsc3xwnzizv9sh4gx52vjcd9";
  snapshotHashLinux686 = "191ed5ec4f17e32d36abeade55a1c6085e51245c";
  snapshotHashLinux64 = "acec86045632f4f3f085c072ba696f889906dffe";
  snapshotHashDarwin686 = "9d9e622584bfa318f32bcb5b9ce6a365febff595";
  snapshotHashDarwin64 = "e96c1e9860b186507cc75c186d1b96d44df12292";
  snapshotDate = "2015-02-17";
  snapshotRev = "f1bb6c2";
  patches = [
    ./patches/alpha2.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

