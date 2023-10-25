{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wamr";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-micro-runtime";
    rev = "WAMR-${finalAttrs.version}";
    hash = "sha256-jpT42up9HAVJpo03cFrffQQk2JiHEAEepBGlU4RUfNU=";
  };

  nativeBuildInputs = [ cmake ];

  sourceRoot = "source/product-mini/platforms/linux";

  meta = with lib; {
    description = "WebAssembly Micro Runtime";
    homepage = "https://github.com/bytecodealliance/wasm-micro-runtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
    # TODO (ereslibre): this derivation should be improved to support
    # more platforms.
    broken = !stdenv.isLinux;
  };
})
