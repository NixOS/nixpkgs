{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cel-go";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cel-go";
    rev = "v${version}";
    hash = "sha256-rjhTKZ2d1jDby4tacLfbKJj0Y7F/KkECWAL/WsqJ6sg=";
  };

  modRoot = "repl";

  vendorHash = "sha256-h+f/ILk6mDzRBW1FI1jFyWxkV3bvrJ/BMsCuuf+E+J0=";

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
