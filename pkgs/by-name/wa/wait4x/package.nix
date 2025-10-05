{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.5.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${version}";
    hash = "sha256-VAt61k2eHQwyLSsvbWxe7jJ/Wyj4U4O2+LzCsoP/Yq4=";
  };

  vendorHash = "sha256-KJOKLTjwwgu2MFNIRDk8eeSVnZyjO9dfVyWrF5vqj9g=";

  # Tests make network access
  doCheck = false;

  meta = with lib; {
    description = "Allows you to wait for a port or a service to enter the requested state";
    homepage = "https://github.com/wait4x/wait4x";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "wait4x";
  };
}
