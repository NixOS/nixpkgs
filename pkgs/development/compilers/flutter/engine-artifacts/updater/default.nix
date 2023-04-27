{ fetchurl, rustPlatform, pkg-config, openssl }:
let
  # this is needed because some deps require shipping a NOTICE but we probably don't want to vendor 2MB non-eval-required data in nixpkgs
  thirdparty_json = fetchurl {
    url = "https://gist.githubusercontent.com/gilice/d7912a0986e138fc4221b3e21e3ec7b1/raw/680346cf6cd8f9f000ae1f69fa859af48d444a8b/THIRDPARTY.JSON";
    sha256 = "sha256-mp1qYwWdcVnznNP7kiIn8iZq4Z+iAsnl9lVD2hnb8jk=";
  };
in
rustPlatform.buildRustPackage {
  pname = "engine-updater";
  version = "0.1.0";
  src = ./.;
  preBuild = ''cp ${thirdparty_json} THIRDPARTY.json'';
  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  cargoSha256 = "sha256-BYJDm5cqV2aiIhKy70rzwOsHx8Sne4ZMpQwcPqqyj+4=";
}
