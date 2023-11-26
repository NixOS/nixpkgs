{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wamr";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-micro-runtime";
    rev = "WAMR-${finalAttrs.version}";
    hash = "sha256-bnia0ORC0YajO7I3XDMdpjlktDqOiXDlGcf12N1G+eg=";
  };

  nativeBuildInputs = [ cmake ];

  sourceRoot = "${finalAttrs.src.name}/product-mini/platforms/linux";

  meta = with lib; {
    description = "WebAssembly Micro Runtime";
    homepage = "https://github.com/bytecodealliance/wasm-micro-runtime";
    license = licenses.asl20;
    mainProgram = "iwasm";
    maintainers = with maintainers; [ ereslibre ];
    # TODO (ereslibre): this derivation should be improved to support
    # more platforms.
    broken = !stdenv.isLinux;
  };
})
