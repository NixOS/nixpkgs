{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  wcwidth,

  # tests
  pytest-lazy-fixtures,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "3.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "prettytable";
    tag = version;
    hash = "sha256-Wx3mt6b+tg3yz0f6r9NVFduLKWr8GBXXJI99RBc1VO4=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ wcwidth ];

  nativeCheckInputs = [
    pytest-lazy-fixtures
    pytestCheckHook
  ];

  pythonImportsCheck = [ "prettytable" ];

  meta = {
    description = "Display tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/jazzband/prettytable";
    changelog = "https://github.com/jazzband/prettytable/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
