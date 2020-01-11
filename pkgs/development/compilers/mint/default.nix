{ lib, fetchFromGitHub, crystal, zlib, openssl_1_0_2, duktape, which, libyaml }:
crystal.buildCrystalPackage rec {
  version = "0.5.0";
  pname = "mint";
  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    sha256 = "0vxbx38c390rd2ysvbwgh89v2232sh5rbsp3nk9wzb70jybpslvl";
  };

  buildInputs = [ openssl_1_0_2 ];

  # Update with
  #   nix-shell -p crystal2nix --run crystal2nix
  # with mint's shard.lock file in the current directory
  shardsFile = ./shards.nix;
  crystalBinaries.mint.src = "src/mint.cr";

  meta = {
    description = "A refreshing language for the front-end web";
    homepage = https://mint-lang.com/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ manveru ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
