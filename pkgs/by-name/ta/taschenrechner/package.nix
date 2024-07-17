{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "taschenrechner";
  version = "1.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.fem-net.de";
    owner = "mabl";
    repo = "taschenrechner";
    rev = version;
    hash = "sha256-5Vml6UeiWz7fNA+vEQ/Ita2YI8dGgDclqkzQ848AwVk=";
  };

  cargoHash = "sha256-BZGkdHR66O3GjKl9yM/bKxdGdvWFB/YO2Egg6V/wuB8=";

  meta = with lib; {
    description = "A cli-calculator written in Rust";
    homepage = "https://gitlab.fem-net.de/mabl/taschenrechner";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ netali ];
    mainProgram = "taschenrechner";
  };
}
