{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "0.4.1";
  pname = "loc";

  src = fetchFromGitHub {
    owner = "cgag";
    repo = "loc";
    rev = "v${version}";
    sha256 = "0086asrx48qlmc484pjz5r5znli85q6qgpfbd81gjlzylj7f57gg";
  };

  cargoHash = "sha256-/YnU7vLz37Y9gggGx+vKWvtxBH0fjBwXGc+UWyOG2OE=";

  meta = {
    homepage = "https://github.com/cgag/loc";
    description = "Count lines of code quickly";
    mainProgram = "loc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
  };
}

