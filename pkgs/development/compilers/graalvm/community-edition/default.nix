{ lib
, pkgs
}:

lib.makeScope pkgs.newScope (self:
{
  stdenv =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.darwin.apple_sdk_11_0.stdenv
    else
      pkgs.stdenv;

  buildGraalvm = self.callPackage ./buildGraalvm.nix;

  buildGraalvmProduct = self.callPackage ./buildGraalvmProduct.nix;

  graalvm-ce = self.callPackage ./graalvm-ce { };

  graalvm-ce-musl = self.callPackage ./graalvm-ce { useMusl = true; };

  graaljs = self.callPackage ./graaljs { };

  graalnodejs = self.callPackage ./graalnodejs { };

  graalpy = self.callPackage ./graalpy { };

  truffleruby = self.callPackage ./truffleruby { };
})
