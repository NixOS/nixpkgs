{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "expr";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-x96I6HHhm3RIrlg1/KVCIbFkelazGt0H2nk8juUWjKg=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-ZVB6P0WdjyDK9OlEgKjR3D3IVBkDbDx9bOpLC/H2JLs=";

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
