{
  lib,
  fetchFromGitHub,
  php,
}:
php.buildComposerProject2 (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "terminus";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "pantheon-systems";
    repo = "terminus";
    tag = finalAttrs.version;
    hash = "sha256-LF3MGmy/lrVzzTtfdGjTIkxB7bzBAzrocrAdWFXvVHM=";
  };

  vendorHash = "sha256-T97sVpokwEWoHPfLbcKw8W02QTuPLTyfzwSnrN+NAR8=";

  meta = {
    description = "Standalone utility for performing operations on the Pantheon Platform";
    homepage = "https://github.com/pantheon-systems/terminus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
    platforms = php.meta.platforms;
    mainProgram = "terminus";
  };
})
