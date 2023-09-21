{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "docstring-parser";
  version = "0.15";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "docstring_parser";
    rev = "refs/tags/${version}";
    hash = "sha256-rnDitZn/xI0I9KMQv6gxzVYevWUymDgyFETjAnRlEHw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "docstring_parser"
  ];

  meta = with lib; {
    description = "Parse Python docstrings in various flavors";
    homepage = "https://github.com/rr-/docstring_parser";
    changelog = "https://github.com/rr-/docstring_parser/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
