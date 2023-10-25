{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cel-go";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cel-go";
    rev = "v${version}";
    hash = "sha256-eXltZkg5QjdCrL9sk2ngVtirSnjBBqk+OdNLY4QtVx4=";
  };

  modRoot = "repl";

  vendorHash = "sha256-kalTHpyMYrKZHayxNKLc8vtogiDKyyQLExOQhqp1MUY=";

  patches = [
    # repl/go.mod and repl/go.sum are outdated
    # ran `go mod tidy` in the repl directory
    ./go-mod-tidy.patch
  ];

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
