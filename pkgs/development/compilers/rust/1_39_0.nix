import ./default.nix {
  rustcVersion = "1.39.0";
  rustcSha256 = "0mwkc1bnil2cfyf6nglpvbn2y0zfbv44zfhsd5qg4c9rm6vgd8dl";

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.38.0";

  # fetch hashes by running `print-hashes.sh 1.38.0`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "41aed8a350e24a0cac1444ed99b3dd24a90bc581dd88cb420c6e547d6b5f57af";
    x86_64-unknown-linux-gnu = "adda26b3f0609dbfbdc2019da4a20101879b9db2134fae322a4e863a069ec221";
    armv7-unknown-linux-gnueabihf = "8b1bf1680a61a643d6b5c7a3b1a1ce88448652756395e20ba5846739cbd085c4";
    aarch64-unknown-linux-gnu = "06afd6d525326cea95c3aa658aaa8542eab26f44235565bb16913ac9d12b7bda";
    i686-apple-darwin = "cdbf2807774bed350a3af6f41d7f7dd7ceff28777cde310c3ba90033188eb2f8";
    x86_64-apple-darwin = "bd301b78ddcd5d4553962b115e1dca5436dd3755ed323f86f4485769286a8a5a";
  };

  selectRustPackage = pkgs: pkgs.rust_1_39_0;
}
