{ callPackage }:

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
    mltonBootstrap = mlton20180207Binary;
    version = "20210117";
    rev = "on-20210117-release";
    sha256 = "sha256-rqL8lnzVVR+5Hc7sWXK8dCXN92dU76qSoii3/4StODM=";
  };

  mltonHEAD = callPackage ./from-git-source.nix {
    mltonBootstrap = mlton20180207Binary;
    version = "HEAD";
    rev = "875f7912a0b135a9a7e86a04ecac9cacf0bfe5e5";
    sha256 = "sha256-/MIoVqqv8qrJPehU7VRFpXtAAo8UUzE3waEvB7WnS9A=";
  };
}
