{ lib, fetchFromGitHub, crystal_0_36, openssl }:

let
  crystal = crystal_0_36;

in
crystal.buildCrystalPackage rec {
  version = "0.11.0";
  pname = "mint";

  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    sha256 = "sha256-QqO4Kc8hf6WNCENPvLwYIF9gtXG/VRR7DhyZvxB4VsA=";
  };

  postPatch = ''
    export HOME=$TMP
  '';

  format = "shards";

  # Update with
  #   nix-shell -p crystal2nix --run crystal2nix
  # with mint's shard.lock file in the current directory
  shardsFile = ./shards.nix;

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A refreshing language for the front-end web";
    homepage = "https://mint-lang.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ manveru ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    broken = lib.versionOlder crystal.version "0.33";
  };
}
