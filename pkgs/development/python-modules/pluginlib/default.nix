{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pluginlib";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rockhopper-Technologies";
    repo = "pluginlib";
    tag = version;
    hash = "sha256-KaexWmRSipwX+tg4Fh03XqhWm2XtZnmy4IEscJDRY/E=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pluginlib"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Framework for creating and importing plugins in Python";
    homepage = "https://github.com/Rockhopper-Technologies/pluginlib";
    changelog = "https://github.com/Rockhopper-Technologies/pluginlib/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      jpds
    ];
  };
}
