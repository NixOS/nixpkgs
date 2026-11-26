{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "archspec";
  version = "0.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "archspec";
    repo = "archspec";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-S9wYgXR+h3CDj33kneykv6Z33Zbpl4QVj4xWCORc0bo=";
  };

  build-system = [ poetry-core ];

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
