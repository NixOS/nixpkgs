{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.5.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${version}";
    hash = "sha256-iHhUimAREKN3o36vi1Ggj8PrhXCHRllxv4yiQ2xcNig=";
  };

  vendorHash = "sha256-N3HYbeBoDuLvWYX+7mrCTYi38hTdK8BP9uY56fOmuls=";

  # Tests make network access
  doCheck = false;

  meta = with lib; {
    description = "Wait4X allows you to wait for a port or a service to enter the requested state";
    homepage = "https://github.com/wait4x/wait4x";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "wait4x";
  };
}
