{
  lib,
  php82,
  fetchFromGitHub,
  versionCheckHook,
}:

php82.buildComposerProject2 (finalAttrs: {
  pname = "box";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    tag = finalAttrs.version;
    hash = "sha256-gYIAP9pTjahNkpNNXx0c8sQm+9Kaq6/IAo/xI5bNy7Y=";
  };

  vendorHash = "sha256-TAubvl+rsdQdqKz+lRg1oX/ENuRyHoJQVmL1ELz24fg=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "Application for building and managing Phars";
    homepage = "https://github.com/box-project/box";
    license = lib.licenses.mit;
    mainProgram = "box";
    maintainers = lib.teams.php.members;
  };
})
