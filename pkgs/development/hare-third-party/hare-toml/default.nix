{ stdenv
, hare
, scdoc
, lib
, fetchFromGitea
, nix-update-script
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-toml";
  version = "0.1.0-unstable-2023-12-27";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lunacb";
    repo = "hare-toml";
    rev = "022d0a8d59e5518029f72724a46e6133b934774c";
    hash = "sha256-DsVcbh1zn8GNKzzb+1o6bfgiVigrxHw/5Xm3uuUhRy0=";
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
