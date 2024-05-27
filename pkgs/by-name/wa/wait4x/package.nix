{ lib
, buildGoModule
, fetchFromGitHub
}:
let
  pname = "wait4x";
  version = "2.14.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "atkrad";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4lv6nYeyjjGGQksi2Ffx+Yu0OazNsJ0QEZG5BfuyrJ8=";
  };

  vendorHash = "sha256-D8s42YArp0IGi7I6qB9eQEh1ZQptSrKLLVIIdqk5Kq0=";

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
