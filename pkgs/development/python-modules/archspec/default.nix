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
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-2rMsxSAnPIVqvsbAUtBbHLb3AvrZFjGzxYO6A/1qXnY=";
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
    changelog = "https://github.com/archspec/archspec/releases/tag/v0.2.1";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ atila ];
  };
}
