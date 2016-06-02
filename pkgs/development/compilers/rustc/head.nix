# Please make sure to check if rustfmt still builds when updating nightly
{ stdenv, callPackage, rustcStable }:

callPackage ./generic.nix {
  shortVersion = "master-1.11.0";
  forceBundledLLVM = false;
  srcRev = "298730e7032cd55809423773da397cd5c7d827d4";
  srcSha = "0hyz5j1z75sjkgsifzgxviv3b1lhgaz8wqwvmq80xx5vd78yd0c1";
  patches = [ ./patches/disable-lockfile-check.patch
              ./patches/use-rustc-1.9.0.patch ] ++
    stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
  rustc = rustcStable;
}
