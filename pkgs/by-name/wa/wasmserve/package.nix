{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wasmserve";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hajimehoshi";
    repo = "wasmserve";
    rev = "v${version}";
    hash = "sha256-e+pHwk+xJVc+Ki0iJC2B+W8ZN4mEawEQNyGhwITBDlo=";
  };

  vendorHash = null;

  meta = {
    description = "HTTP server for testing Wasm";
    mainProgram = "wasmserve";
    homepage = "https://github.com/hajimehoshi/wasmserve";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kirillrdy ];
  };
}
