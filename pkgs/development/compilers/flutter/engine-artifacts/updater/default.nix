{ fetchurl, rustPlatform, pkg-config, openssl, nixpkgs-fmt }:
let
  # this is needed because some deps require shipping a NOTICE but we probably don't want to vendor 2MB non-eval-required data in nixpkgs
  thirdparty_json = fetchurl {
    url = "https://gist.github.com/gilice/23c2030fd532a5ac279650aa454e72d9";
    sha256 = "sha256-mW5wZK9m6CwMp42G5co07y70r9p7QWrZMxek7+wGjQM=";
  };
in
rustPlatform.buildRustPackage {
  pname = "engine-updater";
  version = "0.1.0";
  src = ./.;
  preBuild = ''cp ${thirdparty_json} THIRDPARTY.json'';
  buildInputs = [ openssl nixpkgs-fmt ];
  nativeBuildInputs = [ pkg-config ];
  cargoSha256 = "sha256-BYJDm5cqV2aiIhKy70rzwOsHx8Sne4ZMpQwcPqqyj+4=";
}
