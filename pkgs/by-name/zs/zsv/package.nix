{
  lib,
  stdenv,
  fetchFromGitHub,
  jq,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsv";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ht6sg93bHrNTw1tEEkd9vRl5aIsc1q7nASakvECdyzI=";
  };

  buildInputs = [ jq ];

  configureFlags = [
    "--jq-prefix=${lib.getLib jq}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "World's fastest (simd) CSV parser, with an extensible CLI";
    mainProgram = "zsv";
    homepage = "https://github.com/liquidaty/zsv";
    changelog = "https://github.com/liquidaty/zsv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.all;
  };
})
