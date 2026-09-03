{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zlog";
  version = "1.2.18";

  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = "zlog";
    tag = finalAttrs.version;
    hash = "sha256-79yyOGKgqUR1KI2+ngZd7jfVcz4Dw1IxaYfBJyjsxYc=";
  };

  patches = [
    # upgrade cmake minimum version
    (fetchpatch {
      url = "https://github.com/HardySimpson/zlog/commit/3715879775f725260aeda14f94887bbc7a007e29.patch?full_index=1";
      hash = "sha256-RCI+jZauSO0O0ETjs0nUd4CC2wLLVsjH8iuOmIgWhck=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = "https://hardysimpson.github.io/zlog/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "zlog-chk-conf";
    platforms = lib.platforms.unix;
  };
})
