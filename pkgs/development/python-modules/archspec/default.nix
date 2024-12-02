{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  jsonschema,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "archspec";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "archspec";
    repo = "archspec";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-Xg1XdmKk2b6fqzOdedU3SGIgy65CjExxDByt/Xvmr24=";
  };

  build-system = [ poetry-core ];

  dependecies = [ click ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [ "archspec" ];

  meta = with lib; {
    description = "Library for detecting, labeling, and reasoning about microarchitectures";
    homepage = "https://archspec.readthedocs.io/";
    changelog = "https://github.com/archspec/archspec/releases/tag/v${version}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ atila ];
    mainProgram = "archspec";
  };
}
