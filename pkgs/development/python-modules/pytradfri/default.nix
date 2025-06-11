{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiocoap,
  dtlssocket,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytradfri";
  version = "14.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    tag = version;
    hash = "sha256-oYYi1P0Zu9PLsacUW//BlJlLmeOVvHgb/lR52KwZ7N8=";
  };

  build-system = [ setuptools ];

  dependencies = [ pydantic ];

  optional-dependencies = {
    async = [
      aiocoap
      dtlssocket
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.async;

  pythonImportsCheck = [ "pytradfri" ];

  meta = with lib; {
    description = "Python package to communicate with the IKEA Trådfri ZigBee Gateway";
    homepage = "https://github.com/home-assistant-libs/pytradfri";
    changelog = "https://github.com/home-assistant-libs/pytradfri/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
