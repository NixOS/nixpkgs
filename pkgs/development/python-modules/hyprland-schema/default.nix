{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hyprland-schema";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-schema";
    tag = "v${version}";
    hash = "sha256-voZJ1nCyTqTP1UiPsLOvIamDjNLNJZSKDfZ3lFMkPjs=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_schema" ];

  # test_generate.py requires network access to fetch Hyprland source
  doCheck = false;

  meta = {
    description = "Typed Python schema for every Hyprland configuration option";
    homepage = "https://github.com/BlueManCZ/hyprland-schema";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
}
