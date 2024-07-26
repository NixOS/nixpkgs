{ lib
, buildPythonPackage
, fetchPypi
, marshmallow
, packaging
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "faraday-agent-parameters-types";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "faraday_agent_parameters_types";
    inherit version;
    hash = "sha256-Txw7fXDnuFB9fTETkMhEgjOsjllPQB8IEG3lN3Yj/4k=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn '"pytest-runner",' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    marshmallow
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
