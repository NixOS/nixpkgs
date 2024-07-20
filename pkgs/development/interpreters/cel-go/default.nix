{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cel-go";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cel-go";
    rev = "v${version}";
    hash = "sha256-RN3Eqdf1Zon0gSsP3jGxydVEa0NL5filAei4+xPFNv8=";
  };

  modRoot = "repl";

  vendorHash = "sha256-jNlzsx1QII9UBHQDU7nSzkNLtfbuce4O1AcPaFqtj9c=";

  subPackages = [
    "main"
  ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv $out/bin/{main,cel-go}
  '';

  meta = with lib; {
    description = "Fast, portable, non-Turing complete expression evaluation with gradual typing";
    mainProgram = "cel-go";
    homepage = "https://github.com/google/cel-go";
    changelog = "https://github.com/google/cel-go/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
