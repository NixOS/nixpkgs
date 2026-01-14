{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "port-for";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kmike";
    repo = "port-for";
    tag = "v${version}";
    hash = "sha256-/45TQ2crmTupRgL9hgZGw5IvFKywezSIHqHFbeAkMoo=";
  };

  nativeBuildInputs = [ setuptools ];

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
