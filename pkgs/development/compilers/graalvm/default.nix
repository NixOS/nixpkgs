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

    graalvm-oracle_24 =
      (self.callPackage ./graalvm-oracle { version = "24"; }).overrideAttrs
        (oldAttrs: {
          autoPatchelfIgnoreMissingDeps = [ "libonnxruntime.so.1.18.0" ];
        });
    graalvm-oracle_21 = self.callPackage ./graalvm-oracle { version = "21"; };
    graalvm-oracle = self.graalvm-oracle_24;
  }
  // lib.optionalAttrs config.allowAliases {
    graalvm-oracle_17 = throw "GraalVM 17 is EOL, use a newer version instead";
    graalvm-oracle_22 = throw "GraalVM 22 is EOL, use a newer version instead";
    graalvm-oracle_23 = throw "GraalVM 23 is EOL, use a newer version instead";
  }
)
