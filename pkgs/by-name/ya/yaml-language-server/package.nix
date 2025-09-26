{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yaml-language-server";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "yaml-language-server";
    tag = finalAttrs.version;
    hash = "sha256-HBhoadWIebeuHZXSdnFiPMSmDla77yhrTNMdz8si88c=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-2OVxvvijnfB8Bytgoaybyx4p66nD/aahtyjxLf8womE=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
  ];

  # NodeJS is also needed here so that script interpreter get patched
  buildInputs = [ nodejs ];

  strictDeps = true;

  meta = {
    changelog = "https://github.com/redhat-developer/yaml-language-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Language Server for YAML Files";
    homepage = "https://github.com/redhat-developer/yaml-language-server";
    license = lib.licenses.mit;
    mainProgram = "yaml-language-server";
    maintainers = [ ];
  };
})
