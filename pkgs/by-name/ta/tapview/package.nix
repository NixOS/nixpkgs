{
  asciidoctor,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tapview";
  version = "1.15";

  nativeBuildInputs = [ asciidoctor ];

  src = fetchFromGitLab {
    owner = "esr";
    repo = "tapview";
    tag = finalAttrs.version;
    hash = "sha256-6v+CxNjj3gPE3wmhit6e5OuhkjVACFv/4QAbFDCySGc=";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Minimalist pure consumer for TAP (Test Anything Protocol)";
    mainProgram = "tapview";
    homepage = "https://gitlab.com/esr/tapview";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pamplemousse ];
  };
})
