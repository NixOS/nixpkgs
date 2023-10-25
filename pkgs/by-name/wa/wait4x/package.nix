{ lib
, buildGoModule
, fetchFromGitHub
}:
let
  pname = "wait4x";
  version = "2.13.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "atkrad";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vhYWt1vRL1iTtdZRhk3HsBnmhcp4hieN+8vsyQS4hpo=";
  };

  vendorHash = "sha256-WY8FPRjjAFcDLMbU22pL3rFTw7fBPwCbXJDjhHDI4Kw=";

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
