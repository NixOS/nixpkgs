{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
}:

buildPythonPackage {
  pname = "aocd-example-parser";
  version = "2024.12.25";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "aocd-example-parser";
    rev = "c86bfc714d2f413965a46a2caf3483e823ea9ade";
    hash = "sha256-1Le1jrLCFRJcUngoq5bt22gM1lpAMBNBRWjOl3yLlsw=";
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
