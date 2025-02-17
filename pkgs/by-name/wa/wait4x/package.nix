{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "2.14.3";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "atkrad";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tqUqiq+U+C+1KCsCw9h1uufL1ognUyvLwJfRU8aiAWI=";
  };

  vendorHash = "sha256-KtEOLLsbTfgaXy/0aj5zT5qbgW6qBFMuU3EnnXRu+Ig=";

  # Tests make network access
  doCheck = false;

  meta = with lib; {
    description = "Wait4X allows you to wait for a port or a service to enter the requested state";
    homepage = "https://github.com/atkrad/wait4x";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "wait4x";
  };
}
