{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "farama-notifications";
  version = "0.0.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "farama-notifications";
    tag = finalAttrs.version;
    hash = "sha256-gvOLitPqpJW1kLVZUkf8UVhKdjhCZhu9ORmdLHzil1E=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "farama_notifications" ];

  meta = {
    description = "Allows for providing notifications on import to all Farama Packages";
    homepage = "https://github.com/Farama-Foundation/Farama-Notifications";
    changelog = "https://github.com/Farama-Foundation/Farama-Notifications/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
