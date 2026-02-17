{ callPackage, stdenv }:

rec {
  mlton20130715 = callPackage ./20130715.nix { };

  mlton20180207Binary = callPackage ./20180207-binary.nix { };

  mlton20180207 = callPackage ./from-git-source.nix {
    mltonBootstrap = mlton20180207Binary;
    version = "20180207";
    rev = "on-20180207-release";
    sha256 = "00rdd2di5x1dzac64il9z05m3fdzicjd3226wwjyynv631jj3q2a";
  };

  mlton20210117Binary = callPackage ./20210117-binary.nix { };

  mlton20210117 = callPackage ./from-git-source.nix {
    mltonBootstrap = mlton20210117Binary;
    version = "20210117";
    rev = "on-20210117-release";
    sha256 = "sha256-rqL8lnzVVR+5Hc7sWXK8dCXN92dU76qSoii3/4StODM=";
  };

  mlton20241230 = callPackage ./from-git-source.nix {
    mltonBootstrap = mlton20210117Binary;
    version = "20241230";
    rev = "on-20241230-release";
    sha256 = "sha256-gJUzav2xH8C4Vy5FuqN73Z6lPMSPQgJApF8LgsJXRWo=";
    # https://github.com/MLton/mlton/issues/631
    doCheck = !(stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin);
  };

  mltonHEAD = callPackage ./from-git-source.nix {
    mltonBootstrap = mlton20210117Binary;
    version = "HEAD";
    rev = "61baac7108fbd91413f0537b7a42d9a1023455f4";
    sha256 = "sha256-nWR7ZaXfKxeXfZ9IHipAQ39ASVtva4BeDHP3Zq8mqPo=";
    # https://github.com/MLton/mlton/issues/631
    doCheck = !(stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin);
  };
}
