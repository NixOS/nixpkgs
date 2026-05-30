{
  fetchFromCodeberg,
  fetchpatch,
  hareHook,
  lib,
  nix-update-script,
  scdoc,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-toml";
  version = "0.2.1";

  src = fetchFromCodeberg {
    owner = "lunacb";
    repo = "hare-toml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PAXK7BHPzmZaTm3PIbTTn0ZB/8l6HzOkJ2prARxD9UE=";
  };

  nativeBuildInputs = [
    scdoc
    hareHook
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

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
