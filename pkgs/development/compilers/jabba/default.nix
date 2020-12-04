{ pkgs }:

with pkgs;

{
  adopt = (callPackages ./adopt.nix {});
  adopt-openj9 = (callPackages ./adopt-openj9.nix {});
  graalvm = (callPackages ./graalvm.nix {});
  graalvm-ce-java8 = (callPackages ./graalvm-ce-java8.nix {});
  graalvm-ce-java11 = (callPackages ./graalvm-ce-java11.nix {});
  openjdk = (callPackages ./openjdk.nix {});
  openjdk-ri = (callPackages ./openjdk-ri.nix {});
  zulu = (callPackages ./zulu.nix {});
}
