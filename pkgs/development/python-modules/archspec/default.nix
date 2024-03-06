{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, jsonschema
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "archspec";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "archspec";
    repo = "archspec";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-6+1TiXCBqW8YH/ggZhRcZV/Tyh8Ku3ocwxf9z9KrCZY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [
    "archspec"
  ];

  meta = with lib; {
    description = "Library for detecting, labeling, and reasoning about microarchitectures";
    homepage = "https://archspec.readthedocs.io/";
    changelog = "https://github.com/archspec/archspec/releases/tag/v${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ atila ];
  };
}
