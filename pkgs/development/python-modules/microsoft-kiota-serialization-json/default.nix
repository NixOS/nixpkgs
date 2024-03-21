{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, microsoft-kiota-abstractions
, pendulum
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "kiota-serialization-json";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-serialization-json-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-igMqwoKArfQ37pzdjUICgXY795dfg/MX65iwTVe0sLM=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    microsoft-kiota-abstractions
    pendulum
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "kiota_serialization_json"
  ];

  disabledTests = [
    # Test compare an output format
    "test_parse_union_type_complex_property1"
  ];

  meta = with lib; {
    description = "JSON serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-serialization-json-python";
    changelog = "https://github.com/microsoft/kiota-serialization-json-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
