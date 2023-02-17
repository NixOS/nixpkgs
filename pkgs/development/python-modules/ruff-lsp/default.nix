{ lib
, fetchPypi
, ruff
, pythonOlder
, buildPythonPackage
, hatchling
, pygls
, typing-extensions
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "ruff-lsp";
  version = "0.0.18";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "ruff_lsp";
    sha256 = "sha256-GNOrEQcErJnFb7vESOB0eXmQYp1PCRPJF75YKRawLIc=";
  };

  propagatedBuildInputs = [ hatchling pygls ruff typing-extensions ];

  meta = with lib; {
    description = "A Language Server Protocol implementation for Ruff";
    homepage = "https://github.com/charliermarsh/ruff-lsp";
    changelog = "https://github.com/charliermarsh/ruff-lsp/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ruby0b ];
  };
}
