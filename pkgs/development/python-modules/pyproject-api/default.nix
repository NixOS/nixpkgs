{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build time
  hatchling,
  hatch-vcs,

  # runtime
  packaging,
  tomli,

  # docs
  sphinxHook,
  furo,
  sphinx-autodoc-typehints,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyproject-api";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pyproject-api";
    tag = version;
    hash = "sha256-fWlGGVjB43NPfBRFfOWqZUDQuqOdrFP7jsqq9xOfvaw=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeBuildInputs = [
    # docs
    sphinxHook
    furo
    sphinx-autodoc-typehints
  ];

  dependencies = [ packaging ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyproject_api" ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/pyproject-api/releases/tag/${version}";
    description = "API to interact with the python pyproject.toml based projects";
    homepage = "https://github.com/tox-dev/pyproject-api";
    license = licenses.mit;
    maintainers = [ ];
  };
}
