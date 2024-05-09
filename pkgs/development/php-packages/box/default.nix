{
  lib,
  php82,
  fetchFromGitHub,
}:

php82.buildComposerProject (finalAttrs: {
  pname = "box";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    rev = finalAttrs.version;
    hash = "sha256-58L0eWIuUleb90ICBrmeHEQDVYySX0TdSaJBnBtmBXc=";
  };

  vendorHash = "sha256-9kTqU+1i6ICLOlCZe+JCyKn8VN/67Uk9vmn8ng8+HdI=";

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "An application for building and managing Phars";
    homepage = "https://github.com/box-project/box";
    license = lib.licenses.mit;
    mainProgram = "box";
    maintainers = lib.teams.php.members;
  };
})
