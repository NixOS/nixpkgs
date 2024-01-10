{ lib
, buildPythonPackage
, fetchFromGitHub

# build
, hatchling

# runtime
, terminado

# tests
, pytest-jupyter
, pytest-timeout
, pytestCheckHook
}:

let self = buildPythonPackage rec {
  pname = "jupyter-server-terminals";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "jupyter_server_terminals";
    rev = "refs/tags/v${version}";
    hash = "sha256-RT4rBSSDuIr3d8+hmbiF7rMn94Yr7ekocWeXww0tKlA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    terminado
  ];

  doCheck = false; # infinite recursion

  nativeCheckInputs = [
    pytest-jupyter
    pytest-timeout
    pytestCheckHook
  ] ++ pytest-jupyter.optional-dependencies.server;

  passthru.tests = {
    check = self.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    changelog = "https://github.com/jupyter-server/jupyter_server_terminals/releases/tag/v${version}";
    description = "A Jupyter Server Extension Providing Support for Terminals";
    homepage = "https://github.com/jupyter-server/jupyter_server_terminals";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
};
in self
