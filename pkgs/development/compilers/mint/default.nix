{
  lib,
  fetchFromGitHub,
  crystal,
  libxml2,
  openssl,
}:

crystal.buildCrystalPackage rec {
  pname = "mint";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    hash = "sha256-82Oi9UJ530rZNGa6XxC1hNvRfZQx3fTZxhfSQeZmz54=";
  };

  format = "shards";

  # Update with
  #   nix-shell -p crystal2nix --run crystal2nix
  # with mint's shard.lock file in the current directory
  shardsFile = ./shards.nix;

  nativeBuildInputs = [
    libxml2 # xmllint
  ];

  buildInputs = [ openssl ];

  preCheck = ''
    substituteInPlace spec/spec_helper.cr \
      --replace-fail "clear_env: true" "clear_env: false"
  '';

  meta = {
    description = "Refreshing language for the front-end web";
    mainProgram = "mint";
    homepage = "https://www.mint-lang.com/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ manveru ];
  };
}
