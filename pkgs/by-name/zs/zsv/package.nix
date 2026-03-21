{
  lib,
  stdenv,
  fetchFromGitHub,
  jq,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsv";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Gc9RDrQmayTnCoFHYN8B3gdqR3CPyyLWtO31WpnJ3o=";
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
