{
  fetchFromGitea,
  hareHook,
  lib,
  nix-update-script,
  scdoc,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-toml";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lunacb";
    repo = "hare-toml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R0kKiIDumhpKJ/C980ncI8WL7AphEc0cRhBUGBPBm0M=";
  };

  nativeBuildInputs = [
    scdoc
    hareHook
  ];

  makeFlags = [ "PREFIX=${builtins.placeholder "out"}" ];

  checkTarget = "check_local";

  doCheck = true;

  dontConfigure = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TOML implementation for Hare";
    homepage = "https://codeberg.org/lunacb/hare-toml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onemoresuza ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
