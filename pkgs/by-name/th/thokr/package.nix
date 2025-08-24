{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "thokr";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "thatvegandev";
    repo = "thokr";
    rev = "v${version}";
    sha256 = "0aryfx9qlnjdq3iq2d823c82fhkafvibmbz58g48b8ah5x5fv3ir";
  };

  cargoHash = "sha256-BjUPXsErdLGmZaDIMaY+iV3XcoQHGNZbRmFJb/fblwU=";

  meta = with lib; {
    description = "Typing tui with visualized results and historical logging";
    homepage = "https://github.com/thatvegandev/thokr";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "thokr";
  };
}
