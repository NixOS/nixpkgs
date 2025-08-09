{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "docstring-parser";
  version = "0.16";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "docstring_parser";
    tag = version;
    hash = "sha256-xwV+mgCOC/MyCqGELkJVqQ3p2g2yw/Ieomc7k0HMXms=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docstring_parser" ];

  meta = with lib; {
    description = "Parse Python docstrings in various flavors";
    homepage = "https://github.com/rr-/docstring_parser";
    changelog = "https://github.com/rr-/docstring_parser/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
