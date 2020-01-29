import ./default.nix {
  rustcVersion = "1.38.0";
  rustcSha256 = "101dlpsfkq67p0hbwx4acqq6n90dj4bbprndizpgh1kigk566hk4";
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.37.0";

  # fetch hashes by running `print-hashes.sh 1.37.0`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "74510e0e52a55e65a9f716673c2cda4d2bd427e2453541c6993c77c3ec04acf9";
    x86_64-unknown-linux-gnu = "cb573229bfd32928177c3835fdeb62d52da64806b844bc1095c6225b0665a1cb";
    arm-unknown-linux-gnueabihf = "272739fbb23cf6c2040c1813af9c8c7f386cac37d9de638f22a1816eb96bc0ae";
    armv7-unknown-linux-gnueabihf = "5b87b877f0ed20c6a09ce26e7a15d8c61b26b62484b97e78a51099d0efefec98";
    aarch64-unknown-linux-gnu = "263ef98fa3a6b2911b56f89c06615cdebf6ef676eb9b2493ad1539602f79b6ba";
    i686-apple-darwin = "e45d0c4d882fc6c404ffa6fe790294f4ea96384a2b48804adbf723f3635477a8";
    x86_64-apple-darwin = "b2310c97ffb964f253c4088c8d29865f876a49da2a45305493af5b5c7a3ca73d";
  };

  selectRustPackage = pkgs: pkgs.rust_1_38_0;
}
