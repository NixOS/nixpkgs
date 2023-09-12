{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "expr";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-cPgVpoixZKFVquT2XehVn+j288HWuWKeGeAaTKfoQs4=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-bmWaSemyihr/zTQ1BE/dzCrCYdOWGzs3W3+kwrV5N0U=";

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
