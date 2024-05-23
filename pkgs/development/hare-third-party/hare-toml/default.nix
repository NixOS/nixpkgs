{
  fetchFromGitea,
  hare,
  lib,
  nix-update-script,
  scdoc,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-toml";
  version = "0.1.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lunacb";
    repo = "hare-toml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-r8T7Gy9c5polP+R12q0QRy4075nfGssDnNPQ8ARx/0M=";
  };

  nativeBuildInputs = [
    scdoc
    hare
  ];

  makeFlags = [
    "HARECACHE=.harecache"
    "PREFIX=${builtins.placeholder "out"}"
  ];

  checkTarget = "check_local";

  doCheck = true;

  dontConfigure = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A TOML implementation for Hare";
    homepage = "https://codeberg.org/lunacb/hare-toml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onemoresuza ];
    inherit (hare.meta) platforms badPlatforms;
  };
})
