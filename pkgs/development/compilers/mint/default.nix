{ lib, fetchFromGitHub, crystal, openssl_1_0_2 }:

crystal.buildCrystalPackage rec {
  version = "0.7.1";
  pname = "mint";

  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = pname;
    rev = version;
    sha256 = "18cg96kl4dn89bj6fm3080zzyd1r7rsfi17agdjjayd2v9fgs95l";
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
    maintainers = with maintainers; [ manveru filalex77 ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
