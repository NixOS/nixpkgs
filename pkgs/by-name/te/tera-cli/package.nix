{
  lib,
  fetchFromGitHub,
  rustPlatform,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-7UKdnq5xmkO95Sf9YR3LqS2RoUYGbvWqRYUXNQXfkf0=";

  meta = with lib; {
    description = "Command line utility to render templates from json|toml|yaml and ENV, using the tera templating engine";
    homepage = "https://github.com/chevdor/tera-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ _365tuwe ];
    mainProgram = "tera";
    platforms = platforms.linux;
  };
}
