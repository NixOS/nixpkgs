{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build time
  hatch-fancy-pypi-readme,
  hatchling,
  hatch-vcs,

  # runtime
  packaging,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyproject-api";
  version = "1.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pyproject-api";
    tag = version;
    hash = "sha256-flW5/zWRBsoLyzJKzKlpsnnthZDENyExbhdLyyo9erw=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
    hatch-vcs
  ];

  dependencies = [ packaging ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyproject_api" ];

  meta = {
    changelog = "https://github.com/tox-dev/pyproject-api/releases/tag/${version}";
    description = "API to interact with the python pyproject.toml based projects";
    homepage = "https://github.com/tox-dev/pyproject-api";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
