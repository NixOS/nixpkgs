{
  lib,
  rustPlatform,
  fetchFromGitHub,

  perl,
  pkg-config,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tau-tower";
  version = "0.2.101";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tau-org";
    repo = "tau-tower";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nfPrxkvb09BkmdxAVy9Ltls01xdIlK6CNnGmtQFBar0=";
  };

  cargoHash = "sha256-btmkUoHZgGbAUOwMlfGn66d8lpDgMthrGRHrcBf8okI=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Webradio server - broadcasts audio source to clients";
    homepage = "https://github.com/tau-org/tau-tower";
    mainProgram = "tau-tower";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
