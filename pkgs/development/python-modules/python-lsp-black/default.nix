{ lib
, black
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python-lsp-server
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-lsp-black";
  version = "1.0.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
    rev = "v${version}";
    sha256 = "03k32m4jfqfzrawj69yxhk9kwzsdcwginip77kxdbra2xwgqfc3w";
  };

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ black python-lsp-server ];

  meta = with lib; {
    homepage = "https://github.com/python-lsp/python-lsp-black";
    description = "Black plugin for the Python LSP Server";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
