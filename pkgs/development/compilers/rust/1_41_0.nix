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
, fetchpatch
} @ args:

import ./default.nix {
  rustcVersion = "1.41.0";
  rustcSha256 = "0jypz2mrzac41sj0zh07yd1z36g2s2rvgsb8g624sk4l14n84ijm";

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.40.0";

  # fetch hashes by running `print-hashes.sh 1.40.0`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "d050d3a1c7c45ba9c50817d45bf6d7dd06e1a4d934f633c8096b7db6ae27adc1";
    x86_64-unknown-linux-gnu = "fc91f8b4bd18314e83a617f2389189fc7959146b7177b773370d62592d4b07d0";
    arm-unknown-linux-gnueabihf = "4be9949c4d3c572b69b1df61c3506a3a3ac044851f025d38599612e7caa933c5";
    armv7-unknown-linux-gnueabihf = "ebfe3978e12ffe34276272ee6d0703786249a9be80ca50617709cbfdab557306";
    aarch64-unknown-linux-gnu = "639271f59766d291ebdade6050e7d05d61cb5c822a3ef9a1e2ab185fed68d729";
    i686-apple-darwin = "ea189b1fb0bfda367cde6d43c18863ab4c64ffca04265e5746bf412a186fe1a2";
    x86_64-apple-darwin = "749ca5e0b94550369cc998416b8854c13157f5d11d35e9b3276064b6766bcb83";
  };

  selectRustPackage = pkgs: pkgs.rust_1_41_0;

  rustcPatches = [
    (fetchpatch {
      url = "https://github.com/QuiltOS/rust/commit/f1803452b9e95bfdbc3b8763138b9f92c7d12b46.diff";
      sha256 = "1mzxaj46bq7ll617wg0mqnbnwr1da3hd4pbap8bjwhs3kfqnr7kk";
    })
  ];
}

(builtins.removeAttrs args [ "fetchpatch" ])
