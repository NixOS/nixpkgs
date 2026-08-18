{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "naturalsort";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-naturalsort";
    tag = version;
    hash = "sha256-MBb8yCIs9DW77TKiV3qOHidt8/zi9m2dgyfB3xrdg3A=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "natsort" ];

  meta = {
    description = "Simple natural order sorting API for Python that just works";
    homepage = "https://github.com/xolox/python-naturalsort";
    changelog = "https://github.com/xolox/python-naturalsort/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
