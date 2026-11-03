{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  ply,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonpath-ng";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsonpath-ng";
    repo = "jsonpath-ng";
    tag = "v${version}";
    hash = "sha256-VGAIsdPjmOOgRvXbABm6CF/7jQLX+foKCKjAhorNN04=";
  };

  build-system = [ setuptools ];

  dependencies = [ ply ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/benchmarks"
  ];

  pythonImportsCheck = [ "jsonpath_ng" ];

  meta = {
    description = "JSONPath implementation";
    homepage = "https://github.com/jsonpath-ng/jsonpath-ng";
    changelog = "https://github.com/jsonpath-ng/jsonpath-ng/blob/v${version}/History.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "jsonpath_ng";
  };
}
