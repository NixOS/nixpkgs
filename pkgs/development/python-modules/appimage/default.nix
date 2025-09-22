{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "appimage";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ssh-mitm";
    repo = "appimage";
    tag = version;
    hash = "sha256-d8LwZ4iZ+fwFaBP/IFoKImI/TsYtVD0rllbYN9XP/es=";
  };

  build-system = [ hatchling ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "appimage" ];

  meta = {
    description = "AppImage start scripts";
    homepage = "https://github.com/ssh-mitm/appimage";
    changelog = "https://github.com/ssh-mitm/appimage/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
