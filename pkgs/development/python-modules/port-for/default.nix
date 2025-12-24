{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "port-for";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kmike";
    repo = "port-for";
    tag = "v${version}";
    hash = "sha256-vv2xjXyUh6g7T0zGDAlOs3K+YM18wSE8rEvgSP1ZBL4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "port_for" ];

  meta = {
    homepage = "https://github.com/kmike/port-for";
    description = "Command-line utility and library that helps with TCP port managment";
    mainProgram = "port-for";
    changelog = "https://github.com/kmike/port-for/blob/v${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
