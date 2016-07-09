{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "master-1.11.0";
    forceBundledLLVM = false;
    srcRev = "298730e7032cd55809423773da397cd5c7d827d4";
    srcSha = "0hyz5j1z75sjkgsifzgxviv3b1lhgaz8wqwvmq80xx5vd78yd0c1";
    patches = [ ./patches/disable-lockfile-check.patch
                ./patches/use-rustc-1.9.0.patch ]
      ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "2016.06.07";
    srcRev = "3e70312a2a4ebedace131fc63bb8f27463c5db28";
    srcSha = "0nibzyfjkiqfnq0c00hhqvs856l5qls8wds252p97q5q92yvp40f";
    depsSha256 = "1xbb33aqnf5yyws6gjys9w8kznbh9rh6hw8mpg1hhq1ahipc2j1f";
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
