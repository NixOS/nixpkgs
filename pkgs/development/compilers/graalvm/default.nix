{
  lib,
  pkgs,
  config,
}:

lib.makeScope pkgs.newScope (
  self:
  {
    buildGraalvm = self.callPackage ./community-edition/buildGraalvm.nix;

    buildGraalvmProduct = self.callPackage ./community-edition/buildGraalvmProduct.nix;

    graalvm-ce = self.callPackage ./community-edition/graalvm-ce { };

    graalvm-ce-musl = self.callPackage ./community-edition/graalvm-ce { useMusl = true; };

    graaljs = self.callPackage ./community-edition/graaljs { };

    graalnodejs = self.callPackage ./community-edition/graalnodejs { };

    graalpy = self.callPackage ./community-edition/graalpy { };

    truffleruby = self.callPackage ./community-edition/truffleruby { };

    graalvm-oracle_23 = self.callPackage ./graalvm-oracle { version = "23"; };
    graalvm-oracle_17 = self.callPackage ./graalvm-oracle { version = "17"; };
    graalvm-oracle = self.graalvm-oracle_23;
  }
  // lib.optionalAttrs config.allowAliases {
    graalvm-oracle_22 = throw "GraalVM 22 is EOL, use a newer version instead";
  }
)
