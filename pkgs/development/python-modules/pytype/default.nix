{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

, ninja
, pybind11
, setuptools
, wheel

, attrs
, importlab
, jinja2
, libcst
, networkx
, pydot
, pylint
, tabulate
, toml
, typing-extensions
, pycnite
}:

buildPythonPackage rec {
  pname = "pytype";
  version = "2023.11.29";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "google";
    repo = "pytype";
    rev = version;
    hash = "sha256-+lXgY9Z8zeMuuVaFAmgxC4pTtGLxiPN+pPikn6JCNL8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ninja
    pybind11
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    attrs
    importlab
    jinja2
    libcst
    networkx
    ninja
    pybind11
    pycnite
    pydot
    pylint
    tabulate
    toml
    typing-extensions
  ];

  pythonImportsCheck = [ "pytype" ];

  meta = {
    homepage = "https://github.com/google/pytype";
    description = "A static type analyzer for Python code";
    changelog = "https://github.com/google/pytype/blob/${src.rev}/CHANGELOG";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ jfvillablanca ];
    mainProgram = "pytype";
  };
}
