{
  lib,
  fetchFromGitHub,
  rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tera-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chevdor";
    repo = "tera-cli";
    rev = "v${version}";
    hash = "sha256-mYFvqzSnTljzRbb9W4/hY7fOO35UF31P5M49JkM58R8=";
  };

  cargoHash = "sha256-aG0J9hnkGvz42gOczU3uF3GsmKZWgrLtx8lXOkDwt0c=";

  meta = with lib; {
    description = "Command line utility to render templates from json|toml|yaml and ENV, using the tera templating engine";
    homepage = "https://github.com/chevdor/tera-cli";
    license = licenses.mit;
    maintainers = with maintainers; [_365tuwe];
    mainProgram = "tera";
    platforms = platforms.linux;
  };
}
