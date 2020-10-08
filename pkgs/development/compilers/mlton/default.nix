{ callPackage }:

rec {
  mlton20130715 = callPackage ./20130715.nix {};

  mlton20180207Binary = callPackage ./20180207-binary.nix {};

  mlton20180207 = callPackage ./from-git-source.nix {
    mltonBootstrap = mlton20180207Binary;
    version = "20180207";
    rev = "on-20180207-release";
    sha256 = "00rdd2di5x1dzac64il9z05m3fdzicjd3226wwjyynv631jj3q2a";
  };

  mltonHEAD = callPackage ./from-git-source.nix {
    mltonBootstrap = mlton20180207Binary;
    version = "HEAD";
    rev = "e149c9917cfbfe6aba5c986a958ed76d5cc6cfde";
    sha256 = "0a0j1i0f0fxw2my1309srq5j3vz0kawrrln01gxms2m5hy5dl50d";
  };
}
