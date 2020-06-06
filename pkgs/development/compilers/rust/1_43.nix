# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
# 3. Firefox and Thunderbird should still build on x86_64-linux.

{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.43.0";
  rustcSha256 = "18akhk0wz1my6y9vhardriy2ysc482z0fnjdcgs9gy59kmnarxkm";

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.42.0";

  # fetch hashes by running `print-hashes.sh 1.43.0`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "1c89c12c8fc1a45dcbcb9ee2e21cc634b8453f1d4cdd658269263de686aab4e4";
    x86_64-unknown-linux-gnu = "7d1e07ad9c8a33d8d039def7c0a131c5917aa3ea0af3d0cc399c6faf7b789052";
    arm-unknown-linux-gnueabihf = "6cf776b910d08fb0d1f88be94464e7b20a50f9d8b2ec6372c3c385aec0b70e7a";
    armv7-unknown-linux-gnueabihf = "a36e7f2bd148e325a7b8e7131b4226266cf522b1a2b12d585dad9c38ef68f4d9";
    aarch64-unknown-linux-gnu = "fdd39f856a062af265012861949ff6654e2b7103be034d046bec84ebe46e8d2d";
    x86_64-apple-darwin = "db1055c46e0d54b99da05e88c71fea21b3897e74a4f5ff9390e934f3f050c0a8";
  };

  selectRustPackage = pkgs: pkgs.rust_1_43;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" ])
