{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  marshmallow,
  packaging,
  pytestCheckHook,
  setuptools,
  validators,
}:

buildPythonPackage (finalAttrs: {
  pname = "faraday-agent-parameters-types";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_agent_parameters_types";
    tag = finalAttrs.version;
    hash = "sha256-jYIGIA/IMTZlYNjmcP1nYQJ3g3RRj7n6EMYceHJAH7o=";
  };

  pythonRelaxDeps = [
    "marshmallow"
    "validators"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn '"pytest-runner",' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    marshmallow
    packaging
    validators
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "faraday_agent_parameters_types"
    "faraday_agent_parameters_types.utils"
  ];

  disabledTests = [
    # assert 'Version requested not valid' in "Invalid version: 'hola'"
    "test_incorrect_version_requested"
    # Tests are outdated
    "test_deserialize"
    "test_invalid_data"
    "test_serialize"
  ];

  meta = {
    description = "Collection of Faraday agent parameters types";
    homepage = "https://github.com/infobyte/faraday_agent_parameters_types";
    changelog = "https://github.com/infobyte/faraday_agent_parameters_types/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
