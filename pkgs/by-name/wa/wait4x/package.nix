{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.1.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "atkrad";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8FSWW2S+bUckjgGhaf/GBH40jnjl4+tPO8KD1qu+Uw0=";
  };

  vendorHash = "sha256-ZHrhnIHRIkM0QLVXbaQAK8FzVTXz7BPegWNiTBQgAWo=";

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
