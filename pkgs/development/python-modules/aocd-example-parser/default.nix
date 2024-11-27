{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aocd-example-parser";
  version = "2023.12.20";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "aocd-example-parser";
    rev = "07330183f3e43401444fe17b08d72eb6168504e1";
    hash = "sha256-iOxqzZj29aY/xyigir1KOU6GcBBvnlxEOBLHChEQjf4=";
  };

  nativeBuildInputs = [ flit-core ];

  # Circular dependency with aocd
  # pythonImportsCheck = [
  #   "aocd_example_parser"
  # ];

  meta = with lib; {
    description = "Default implementation of an example parser plugin for advent-of-code-data";
    homepage = "https://github.com/wimglenn/aocd-example-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
