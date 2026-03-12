{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  packaging,
  pytestCheckHook,
  setuptools,
  validators,
}:
let
  marshmallow' = marshmallow.overrideAttrs (super: {
    version = "3.26.2";
    src = fetchFromGitHub {
      owner = "marshmallow-code";
      repo = "marshmallow";
      tag = "3.26.2";
      hash = "sha256-ioe+aZHOW8r3wF3UknbTjAP0dEggd/NL9PTkPVQ46zM=";
    };
    disabledTests = super.disabledTests ++ [
      "test_from_timestamp_with_overflow_value"
    ];
  });
in
buildPythonPackage (finalAttrs: {
  pname = "faraday-agent-parameters-types";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_agent_parameters_types";
    tag = finalAttrs.version;
    hash = "sha256-Oe/9/zKOoCLK3JHMacOhk2+d91MrhzkBTW3POoFm71M=";
  };

  pythonRelaxDeps = [ "validators" ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn '"pytest-runner",' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    marshmallow'
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
  ];

  meta = {
    description = "Collection of Faraday agent parameters types";
    homepage = "https://github.com/infobyte/faraday_agent_parameters_types";
    changelog = "https://github.com/infobyte/faraday_agent_parameters_types/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
