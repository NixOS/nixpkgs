{
  lib,
  buildPythonPackage,
  fetchPypi,
  marshmallow,
  packaging,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "faraday-agent-parameters-types";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "faraday_agent_parameters_types";
    inherit version;
    hash = "sha256-9+scGbRITK25XLJOMsMzPj/y5Wi05mB0dcXDhon9Cf4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn '"pytest-runner",' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    marshmallow
    packaging
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

  meta = with lib; {
    description = "Collection of Faraday agent parameters types";
    homepage = "https://github.com/infobyte/faraday_agent_parameters_types";
    changelog = "https://github.com/infobyte/faraday_agent_parameters_types/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
