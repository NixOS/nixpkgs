{ lib, fetchFromGitHub, crystal, openssl_1_0_2 }:

crystal.buildCrystalPackage rec {
  version = "0.6.0";
  pname = "mint";
  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    sha256 = "1fq2530m96wlxz2qlgvjjsiid6qygbmywiy203dlsr81czzpvkrh";
  };

  buildInputs = [ openssl_1_0_2 ];

  # Update with
  #   nix-shell -p crystal2nix --run crystal2nix
  # with mint's shard.lock file in the current directory
  shardsFile = ./shards.nix;
  crystalBinaries.mint.src = "src/mint.cr";

  meta = with lib; {
    description = "A refreshing language for the front-end web";
    homepage = "https://mint-lang.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ manveru ];
  };
}
