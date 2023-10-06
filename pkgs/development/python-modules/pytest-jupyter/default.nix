{ lib
, buildPythonPackage
, fetchFromGitHub

# build
, hatchling
, pytest

# runtime
, jupyter-core

# optionals
, jupyter-client
, ipykernel
, jupyter-server
, nbformat

# tests
, pytest-timeout
, pytestCheckHook
}:

let self = buildPythonPackage rec {
  pname = "pytest-jupyter";
  version = "0.6.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pytest-jupyter";
    rev = "refs/tags/v${version}";
    hash = "sha256-kY4QHrlj0opEBywe4SpwE4Ck6l6JIzEosx6uuXh+yCQ=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    jupyter-core
  ];

  passthru.optional-dependencies = rec {
    client = [
      jupyter-client
      ipykernel
    ];
    server = [
      jupyter-server
      nbformat
    ] ++ client;
  };

  doCheck = false; # infinite recursion with jupyter-server

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  passthru.tests = {
    check = self.overridePythonAttrs (_: { doCheck = false; });
  };

  meta = with lib; {
    changelog = "https://github.com/jupyter-server/pytest-jupyter/releases/tag/v${version}";
    description = "pytest plugin for testing Jupyter core libraries and extensions";
    homepage = "https://github.com/jupyter-server/pytest-jupyter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
};
in self
