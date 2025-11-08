{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  napalm,
  librouteros,
  pytestCheckHook,
  pythonAtLeast,
}:
buildPythonPackage rec {
  pname = "napalm-ros";
  version = "1.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napalm-automation-community";
    repo = "napalm-ros";
    tag = version;
    hash = "sha256-Fv11Blx44vZZ8NuhQQIFpDr+dH2gDJtQP7b0kAk3U/s=";
  };

  build-system = [ setuptools ];

  dependencies = [ librouteros ];

  nativeCheckInputs = [
    napalm
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Some methods vary.
    "test_method_signatures"
  ];

  pythonImportsCheck = [ "napalm_ros" ];

  meta = {
    description = "MikroTik RouterOS NAPALM driver";
    homepage = "https://github.com/napalm-automation-community/napalm-ros";
    changelog = "https://github.com/napalm-automation-community/napalm-ros/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
