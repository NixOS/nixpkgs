{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, ruff
, pygls
, typing-extensions
}:

buildPythonPackage rec {
  pname = "ruff-lsp";
  version = "0.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-23pGHF8OGxRXlHVUYlHllccMJULqNdksKX8mzNx4MC8=";
  };

  postPatch = ''
    # ruff is used as a binary, not imported as a python module
    substituteInPlace pyproject.toml --replace 'ruff = ">0.0.150"' ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pygls ruff typing-extensions ];

  pythonImportsCheck = [ "ruff_lsp" ];

  meta = with lib; {
    description = "A Language Server Protocol implementation for Ruff";
    homepage = "https://github.com/charliermarsh/ruff-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
