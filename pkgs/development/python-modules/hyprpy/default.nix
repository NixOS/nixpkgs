{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pydantic,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hyprpy";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "ulinja";
    repo = "hyprpy";
    tag = "v${version}";
    hash = "sha256-hhy9kVslz5ldvNXgChnRmCJ8ONmXiPP/BLAxkV2lG0s=";
  };

  pyproject = true;
  disabled = pythonOlder "3.7";
  build-system = [
    setuptools
  ];

  dependencies = [
    pydantic
  ];

  doCheck = false;
  pythonImportsCheck = [ "hyprpy" ];

  meta = with lib; {
    description = "Python bindings for Hyprland";
    homepage = "https://github.com/ulinja/hyprpy";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ ulinja ];
    changelog = "https://github.com/ulinja/hyprpy/blob/v${version}/CHANGELOG.md";
    platforms = lib.platforms.linux;
  };
}
