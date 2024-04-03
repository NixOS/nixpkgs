{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "expr";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-XTI4TPViNQUPrIPZRWcaxFpkqMUOdGN162f+deFNRR0=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-ZIF0uCGrzs1nn06ouF/eJY1adOw8diAjMIhygZhrXuM=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv $out/bin/{repl,expr}
  '';

  meta = with lib; {
    description = "Expression language and expression evaluation for Go";
    homepage = "https://github.com/antonmedv/expr";
    changelog = "https://github.com/antonmedv/expr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "expr";
  };
}
