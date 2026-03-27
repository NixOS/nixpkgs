{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage {
  pname = "aocd-example-parser";
  version = "2025.12.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "aocd-example-parser";
    rev = "6331ed538dcb25c6d9fd2ef679ccd361ea4ea0af";
    hash = "sha256-RgTs17TxLhmexkWjPTWMcERVrmPkhMZfVL195JVToU0=";
  };

  build-system = [ flit-core ];

  # Circular dependency with aocd

  meta = {
    description = "Default implementation of an example parser plugin for advent-of-code-data";
    homepage = "https://github.com/wimglenn/aocd-example-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
