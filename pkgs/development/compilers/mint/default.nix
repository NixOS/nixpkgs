{ lib, fetchFromGitHub, crystal_0_33, openssl }:

let crystal = crystal_0_33;
in crystal.buildCrystalPackage rec {
  version = "0.9.0";
  pname = "mint";

  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    sha256 = "0y1qr616x7s0pjgih6s1n4wiwb8kn8l1knnzmib6j4jmqax0jhz0";
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
