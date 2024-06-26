{ lib, fetchFromGitHub, crystal, openssl }:

crystal.buildCrystalPackage rec {
  version = "0.19.0";
  pname = "mint";

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

  meta = with lib; {
    description = "Refreshing language for the front-end web";
    mainProgram = "mint";
    homepage = "https://www.mint-lang.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ manveru ];
    broken = lib.versionOlder crystal.version "1.0";
  };
}
