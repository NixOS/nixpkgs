{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "expr";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "expr";
    rev = "v${version}";
    hash = "sha256-K5UIBkuTXsMaSUhys2Ij7JCwdLE/aZiiipiSucgtkIk=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-Sc4Md9O32SOQIyEbIkkJUiowEhLtQN6JzTymk9o3nWE=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Expression language and expression evaluation for Go";
    homepage = "https://github.com/antonmedv/expr";
    changelog = "https://github.com/antonmedv/expr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "expr";
  };
}
