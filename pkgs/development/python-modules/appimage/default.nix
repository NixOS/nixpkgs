{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "appimage";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ssh-mitm";
    repo = "appimage";
    tag = finalAttrs.version;
    hash = "sha256-fH8nAQVpU6GD5Xamm0MhRmGhBTwx7GIsymsijLeq1IM=";
  };

  build-system = [ hatchling ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "appimage" ];

  meta = {
    description = "AppImage start scripts";
    homepage = "https://github.com/ssh-mitm/appimage";
    changelog = "https://github.com/ssh-mitm/appimage/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
