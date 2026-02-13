{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wasmserve";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "hajimehoshi";
    repo = "wasmserve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sj2PPCuvh2RkQq5rAPQZdr96a8FG7RL5RCzWBDt2TeI=";
  };

  vendorHash = null;

  meta = {
    description = "HTTP server for testing Wasm";
    mainProgram = "wasmserve";
    homepage = "https://github.com/hajimehoshi/wasmserve";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kirillrdy ];
  };
})
