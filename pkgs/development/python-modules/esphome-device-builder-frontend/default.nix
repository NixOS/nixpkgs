{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  setuptools,
  nodejs,
  npmHooks,
}:

buildPythonPackage (finalAttrs: {
  pname = "esphome-device-builder-frontend";
  version = "0.1.207";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "device-builder-frontend";
    tag = finalAttrs.version;
    hash = "sha256-63f9i0LC1xyNuB0rbH3/3N5RkOtRWXxjb2NBJcy85ao=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  npmDeps = fetchNpmDeps {
    src = finalAttrs.src;
    hash = "sha256-eMG0zuShFWuteaz8Zb8S8bZo7UAmjnKyhQSbZWfqIXU=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  preBuild = ''
    npm run build
  '';

  meta = {
    changelog = "https://github.com/esphome/esphome-device-builder-frontend/releases/tag/${finalAttrs.src.tag}";
    description = "Frontend for the ESPHome Device Builder";
    homepage = "https://github.com/esphome/esphome-device-builder-frontend";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ DavidvtWout ];
  };
})
