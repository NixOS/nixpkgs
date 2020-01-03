# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
# 3. Firefox and Thunderbird should still build on x86_64-linux.
import ./default.nix {
  rustcVersion = "1.40.0";
  rustcSha256 = "1ba9llwhqm49w7sz3z0gqscj039m53ky9wxzhaj11z6yg1ah15yx";

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.39.0";

  # fetch hashes by running `print-hashes.sh 1.39.0`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "36e31b3069c5be4b1fe3c8f7588ca787f13f91ab7170d2b24c6b07285816d0e5";
    x86_64-unknown-linux-gnu = "b10a73e5ba90034fe51f0f02cb78f297ed3880deb7d3738aa09dc5a4d9704a25";
    arm-unknown-linux-gnueabihf = "ea08d78a718cd34e67733526c70f3be460605dec8284bdeda36e0c6dd6222eca";
    armv7-unknown-linux-gnueabihf = "41186745a97e6b76fb7a3a049882fb4869b526e98a66c05a133518515037f0d7";
    aarch64-unknown-linux-gnu = "e27dc8112fe577012bd88f30e7c92dffd8c796478ce386c49465c03b6db8209f";
    i686-apple-darwin = "0ada2ed87cc449ed470dce3b57b15bfd5c8c52b01d6116e6b1edc9a3e97836aa";
    x86_64-apple-darwin = "3736d49c5e9592844e1a5d5452883aeaf8f1e25d671c1bc8f01e81c1766603b5";
  };

  selectRustPackage = pkgs: pkgs.rust_1_40_0;
}
