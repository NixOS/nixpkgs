{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: {
  buildGraalvm = self.callPackage ./community-edition/buildGraalvm.nix;

  buildGraalvmProduct = self.callPackage ./community-edition/buildGraalvmProduct.nix;

  graalvm-ce = self.callPackage ./community-edition/graalvm-ce { };

  graalvm-ce-musl = self.callPackage ./community-edition/graalvm-ce { useMusl = true; };

  graaljs = self.callPackage ./community-edition/graaljs { };

  graalnodejs = self.callPackage ./community-edition/graalnodejs { };

  graalpy = self.callPackage ./community-edition/graalpy { };

  truffleruby = self.callPackage ./community-edition/truffleruby { };

  graalvm-oracle_22 = self.callPackage ./graalvm-oracle { version = "22"; };
  graalvm-oracle_17 = self.callPackage ./graalvm-oracle { version = "17"; };
  graalvm-oracle = self.graalvm-oracle_22;
})
