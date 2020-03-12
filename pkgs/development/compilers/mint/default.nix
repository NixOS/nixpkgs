{ lib, fetchFromGitHub, crystal, zlib, openssl, duktape, which, libyaml }:
crystal.buildCrystalPackage rec {
  version = "0.7.1";
  pname = "mint";
  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    sha256 = "18cg96kl4dn89bj6fm3080zzyd1r7rsfi17agdjjayd2v9fgs95l";
  };

  buildInputs = [ openssl ];

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
