{ stdenv
, hare
, scdoc
, lib
, fetchFromGitea
, fetchpatch
, nix-update-script
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-toml";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lunacb";
    repo = "hare-toml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JKK5CcDmAW7FH7AzFwgsr9i13eRSXDUokWfZix7f4yY=";
  };

  patches = [
    # Remove `abort()` calls from never returning expressions.
    (fetchpatch {
      name = "remove-abort-from-never-returning-expressions.patch";
      url = "https://codeberg.org/lunacb/hare-toml/commit/f26e7cdfdccd2e82c9fce7e9fca8644b825b40f1.patch";
      hash = "sha256-DFbrxiaV4lQlFmMzo5GbMubIQ4hU3lXgsJqoyeFWf2g=";
    })
    # Fix make's install target to install the correct files
    (fetchpatch {
      name = "install-correct-files-with-install-target.patch";
      url = "https://codeberg.org/lunacb/hare-toml/commit/b79021911fe7025a8f5ddd97deb2c4d18c67b25e.patch";
      hash = "sha256-IL+faumX6BmdyePXTzsSGgUlgDBqOXXzShupVAa7jlQ=";
    })
  ];

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
