{
  fetchFromGitHub,
  lib,
  stdenv,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ts-warp";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "mezantrop";
    repo = "ts-warp";
    rev = finalAttrs.version;
    hash = "sha256-iozjUHdiiP9Wg86W/LGUucd3sLC8gHMcYAbyAHT7WrQ=";
  };

  nativeBuildInputs = [ which ];

  env.PREFIX = "$(out)";

  meta = {
    description = "Transparent proxy server and traffic wrapper";
    homepage = "https://github.com/mezantrop/ts-warp";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    changelog = "https://github.com/mezantrop/ts-warp/blob/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ heywoodlh ];
    mainProgram = "ts-warp";
  };
})
