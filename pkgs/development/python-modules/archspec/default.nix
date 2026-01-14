{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  jsonschema,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "archspec";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "archspec";
    repo = "archspec";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-BfjFNwfNyT/da0Z5/bBdbv+RT8lqM0s2q64cz79vuF0=";
  };

  build-system = [ poetry-core ];

  dependecies = [ click ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [ "archspec" ];

  meta = {
    description = "Library for detecting, labeling, and reasoning about microarchitectures";
    homepage = "https://archspec.readthedocs.io/";
    changelog = "https://github.com/archspec/archspec/releases/tag/${src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ atila ];
    mainProgram = "archspec";
  };
}
