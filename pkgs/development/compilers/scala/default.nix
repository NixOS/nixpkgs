{ callPackage
, jdk8
}:

{
  scala_2_10 = callPackage ./package.nix { majorVersion = "2.10"; jre = jdk8; };
  scala_2_11 = callPackage ./package.nix { majorVersion = "2.11"; jre = jdk8; };
  scala_2_12 = callPackage ./package.nix { majorVersion = "2.12"; };
  scala_2_13 = callPackage ./package.nix { majorVersion = "2.13"; };
  scala_3_3 = callPackage ./package.nix { majorVersion = "3.3"; };
  scala_3_4 = callPackage ./package.nix { majorVersion = "3.4"; };
}
