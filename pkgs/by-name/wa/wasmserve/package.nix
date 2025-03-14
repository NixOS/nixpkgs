{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wasmserve";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "hajimehoshi";
    repo = "wasmserve";
    rev = "v${version}";
    hash = "sha256-k8g5ZCMm0xek+rToq9azE7mOUHU5eF8PxgBcXs6LrJk=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "HTTP server for testing Wasm";
    mainProgram = "wasmserve";
    homepage = "https://github.com/hajimehoshi/wasmserve";
    license = licenses.asl20;
    maintainers = with maintainers; [ kirillrdy ];
  };
}
