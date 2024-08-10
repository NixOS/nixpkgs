{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cel-go";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cel-go";
    rev = "v${version}";
    hash = "sha256-t451e3Pkkt4pmBvS0DBSHOVg7P8ipJd28XyiQ6P/QIQ=";
  };

  modRoot = "repl";

  vendorHash = "sha256-t/GEbpnqpLQ79ETqS9TAgy+2z9FoifAmkHbfKUxDBZA=";

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
