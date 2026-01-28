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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ulinja";
    repo = "hyprpy";
    tag = "v${version}";
    hash = "sha256-b312PmJoVPT5Dt695JdTgDCVlm2LcD0hMmsRUqs3VcQ=";
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
