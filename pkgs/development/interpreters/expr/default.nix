{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "expr";
  version = "1.16.4";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-evPzHLetmCqGnFNydbjUcVIBdcOWrhqaeBIwWB2G6hk=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-GEFLIvshlnCk8pYIf9ZoNV5NBC1R52x12aIOdsAqwFI=";

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
