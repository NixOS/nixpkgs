{
  fetchFromGitea,
  fetchpatch,
  hareHook,
  lib,
  nix-update-script,
  scdoc,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-toml";
  version = "0.1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lunacb";
    repo = "hare-toml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MfflJElDMu15UBuewssqhCEsNtzmN/H421H4HV+JCWc=";
  };

  patches = [
    # Update strconv module functions for 0.24.2
    (fetchpatch {
      url = "https://codeberg.org/lunacb/hare-toml/commit/9849908ba1fd3457abd6c708272ecb896954d2bc.patch";
      hash = "sha256-herJZXJ8uusTO2b7Ddby2chIvDRuAPDFOPEt+wotTA0=";
    })
  ];

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
