{
  lib,
  fetchFromGitHub,
  rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tera-cli";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "chevdor";
    repo = "tera-cli";
    rev = "v${version}";
    hash = "sha256-W+pcVLxOlikwAGvx0twm23GyCMzdqnHY0YBNtcsSB5I=";
  };

  cargoHash = "sha256-A01mok8KQk1FV8P7E4svdBCW6xqpduHy1XuUcdDFjfc=";

  meta = with lib; {
    description = "A command line utility to render templates from json|toml|yaml and ENV, using the tera templating engine";
    homepage = "https://github.com/chevdor/tera-cli";
    license = licenses.mit;
    maintainers = with maintainers; [_365tuwe];
    mainProgram = "tera";
    platforms = platforms.linux;
  };
}
