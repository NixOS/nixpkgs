{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  zlib,
  bzip2,
  xz,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wandio";
  version = "4.2.6-1";

  src = fetchFromGitHub {
    owner = "LibtraceTeam";
    repo = "wandio";
    tag = finalAttrs.version;
    hash = "sha256-fYSAmuTgik8YeonHQc+GHRQ1lEuWxlE17npVsMpBlOE=";
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    zlib
    bzip2
    xz
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^([0-9.-]+)$" ]; };

  meta = {
    description = "C library for simple and efficient file IO";
    homepage = "https://github.com/LibtraceTeam/wandio";
    changelog = "https://github.com/LibtraceTeam/wandio/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.unix;
  };
})
