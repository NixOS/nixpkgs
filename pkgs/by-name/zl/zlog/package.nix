{
  lib,
  stdenv,
  fetchFromGitHub,
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
