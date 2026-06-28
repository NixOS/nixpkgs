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
  version = "0.2.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tau-org";
    repo = "tau-tower";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vbUR2ZfnomUkWdz2xdFReR6B0lzz4dKM88RonAWu994=";
  };

  cargoHash = "sha256-Qv97FTiccfQSBI2OBfl31p3oF/JCL/+UXkK+owuByDY=";

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
