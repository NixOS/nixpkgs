{ lib, fetchFromGitHub, crystal, openssl }:

crystal.buildCrystalPackage rec {
  version = "0.15.3";
  pname = "mint";

  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    hash = "sha256-VjQ736RWP9HK0QFKbgchnEPYH/Ny2w8SI/xnO3m94B8=";
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
    description = "A refreshing language for the front-end web";
    homepage = "https://www.mint-lang.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ manveru ];
    broken = lib.versionOlder crystal.version "1.0";
  };
}
