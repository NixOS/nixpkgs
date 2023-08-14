{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cel-go";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cel-go";
    rev = "v${version}";
    hash = "sha256-qk7jopOr/woWCi5j509K4bdlIybuZZ+UFTmTHEEw9/Y=";
  };

  sourceRoot = "${src.name}/repl";

  vendorHash = "sha256-OypSL91/2FVCF3ADNSJH33JxH0+3HxIziwmXHb/vZM4=";

  subPackages = [
    "main"
  ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv $out/bin/{main,cel-go}
  '';

  meta = with lib; {
    description = "Fast, portable, non-Turing complete expression evaluation with gradual typing";
    homepage = "https://github.com/google/cel-go";
    changelog = "https://github.com/google/cel-go/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
