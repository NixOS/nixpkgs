{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.3.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QmuBoUHOZf6VKrh00BXFxT2e+gJL1gyv9BnhGaWVAD0=";
  };

  vendorHash = "sha256-EqJDw88BqKfIUE/YoDNoI249covv5bzEcx9ykfUkik8=";

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
