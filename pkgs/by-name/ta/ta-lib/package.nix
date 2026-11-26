{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ta-lib";
  version = "0.8.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mctOWXfnrZT7G6BJhCNVy8KwwsjEkRyohZL0rnvoFIE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Technical analysis library: indicators and candlestick patterns, batch and streaming, native in C, Rust, Java, C#... and more";
    mainProgram = "ta-lib-config";
    homepage = "https://ta-lib.org";
    changelog = "https://github.com/TA-Lib/ta-lib/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rafael ];
  };
})
