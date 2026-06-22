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
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "archspec";
    repo = "archspec";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-vtOntxkHlkO0aRS6nRknz+9AYiKtHPoeG8iAw49QsvE=";
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
    maintainers = [ ];
    mainProgram = "archspec";
  };
}
