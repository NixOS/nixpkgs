{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  jq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsv";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5tvWNp8nuYsfGv/PZR/sbOtwGsGKBdi86TIVxfEamho=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ jq ];

  configureFlags = [
    "--jq-prefix=${lib.getLib jq}"
  ];

  meta = {
    description = "World's fastest (simd) CSV parser, with an extensible CLI";
    mainProgram = "zsv";
    homepage = "https://github.com/liquidaty/zsv";
    changelog = "https://github.com/liquidaty/zsv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
