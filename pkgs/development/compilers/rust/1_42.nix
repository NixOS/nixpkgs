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
  rustcVersion = "1.42.0";
  rustcSha256 = "0x9lxs82may6c0iln0b908cxyn1cv7h03n5cmbx3j1bas4qzks6j";

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.41.0";

  # fetch hashes by running `print-hashes.sh 1.42.0`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "a93a34f9cf3d35de2496352cb615b42b792eb09db3149b3a278efd2c58fa7897";
    x86_64-unknown-linux-gnu = "343ba8ef7397eab7b3bb2382e5e4cb08835a87bff5c8074382c0b6930a41948b";
    arm-unknown-linux-gnueabihf = "d0b33fcc97eeb96d716b30573c7e66affdf9077ecdecb30df2498b49f8284047";
    armv7-unknown-linux-gnueabihf = "3c8e787fb4f4f304a065e78c38010f0b5722d809f9dafb0e904084bf0f54f7be";
    aarch64-unknown-linux-gnu = "79ddfb5e2563d0ee09a567fbbe121a2aed3c3bc61255b2787f2dd42183a10f27";
    i686-apple-darwin = "628134b3fbaf5c0e7a25bd9a2b8d25f6e68bb256c8b04a3332ec979f5a1cd339";
    x86_64-apple-darwin = "b6504003ab70b11f278e0243a43ba9d6bf75e8ad6819b4058a2b6e3991cc8d7a";
  };

  selectRustPackage = pkgs: pkgs.rust_1_42;

  rustcPatches = [
    ./0001-Allow-getting-no_std-from-the-config-file.patch
  ];
}

(builtins.removeAttrs args [ "fetchpatch" ])
