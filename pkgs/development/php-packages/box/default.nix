{ lib, php, fetchFromGitHub }:

php.buildComposerProject (finalAttrs: {
  pname = "box";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    rev = finalAttrs.version;
    hash = "sha256-6icHXRxqre2RBIRoc3zfQnxGRHh2kIen2oLJ3eQjD/0=";
  };

  vendorHash = "sha256-n/F/il1u+3amSVf8fr0scZSkXuwxW43iq5F2XQJ3xfM=";

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "An application for building and managing Phars";
    homepage = "https://github.com/box-project/box";
    license = lib.licenses.mit;
    mainProgram = "box";
    maintainers = lib.teams.php.members;
  };
})
