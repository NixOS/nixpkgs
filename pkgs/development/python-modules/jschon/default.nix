{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  rfc3986,
  setuptools,

  # for tests
  pytestCheckHook,
  tox,
  coverage,
  hypothesis,
  pytest-benchmark,
  pytest-httpserver,
  requests,
}:

buildPythonPackage rec {
  pname = "jschon";
  pyproject = true;
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "marksparkza";
    repo = "jschon";
    rev = "refs/tags/v${version}";
    hash = "sha256-uOvEIEUEILsoLuV5U9AJCQAlT4iHQhsnSt65gfCiW0k=";
    fetchSubmodules = true;
  };

  dependencies = [
    setuptools
    rfc3986
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tox
    coverage
    hypothesis
    pytest-benchmark
    pytest-httpserver
    requests
  ];

  pythonImportsCheck = [ "jschon" ];

  meta = with lib; {
    description = "Object-oriented JSON Schema implementation for Python";
    homepage = "https://github.com/marksparkza/jschon";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
