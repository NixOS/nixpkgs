{
  lib,
  pkgs,
}:

lib.makeScope pkgs.newScope (self: {
  buildGraalvm = self.callPackage ./buildGraalvm.nix;

  buildGraalvmProduct = self.callPackage ./buildGraalvmProduct.nix;

  graalvm-ce = self.callPackage ./graalvm-ce { };

  graalvm-ce-musl = self.callPackage ./graalvm-ce { useMusl = true; };

  graaljs = self.callPackage ./graaljs { };

  graalnodejs = self.callPackage ./graalnodejs { };

  graalpy = self.callPackage ./graalpy { };

  truffleruby = self.callPackage ./truffleruby { };
})
