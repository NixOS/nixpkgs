{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "expr";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-4BYFFuoKI5EdxBrgMi33PgjXL6TI7jOQ8H7jLlNKfks=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-vQmQdPmfZtudnFqqNeMRdbRVytpbcCt/wH1xSTO+cMQ=";

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
