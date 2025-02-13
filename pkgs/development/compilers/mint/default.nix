{
  lib,
  fetchFromGitHub,
  crystal,
  openssl,
}:

crystal.buildCrystalPackage rec {
  pname = "mint";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    hash = "sha256-s/ehv8Z71nWnxpajO7eR4MxoHppqkdleFluv+e5Vv6I=";
  };

  format = "shards";

  # Update with
  #   nix-shell -p crystal2nix --run crystal2nix
  # with mint's shard.lock file in the current directory
  shardsFile = ./shards.nix;

  buildInputs = [ openssl ];

  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Refreshing language for the front-end web";
    mainProgram = "mint";
    homepage = "https://www.mint-lang.com/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ manveru ];
  };
}
