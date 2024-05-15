{
  lib,
  php82,
  fetchFromGitHub,
}:

php82.buildComposerProject (finalAttrs: {
  pname = "box";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    rev = finalAttrs.version;
    hash = "sha256-gYIAP9pTjahNkpNNXx0c8sQm+9Kaq6/IAo/xI5bNy7Y=";
  };

  vendorHash = "sha256-HCbjW4HdyQNWDEHXj9U1t3S3EKcrPV1z/9I1ClFsMsc=";

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "An application for building and managing Phars";
    homepage = "https://github.com/box-project/box";
    license = lib.licenses.mit;
    mainProgram = "box";
    maintainers = lib.teams.php.members;
  };
})
