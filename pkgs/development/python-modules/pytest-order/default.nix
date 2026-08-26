{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  pytest-xdist,
  pytest-dependency,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-order";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-order";
    tag = "v${version}";
    hash = "sha256-LLQy5dO3OWmm7W9eI8yfrOFVp9MQOU+pjoAyWl03tZ0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-dependency
    pytest-mock
  ];

  strictDeps = true;

  meta = {
    description = "Pytest plugin that allows you to customize the order in which your tests are run";
    homepage = "https://github.com/pytest-dev/pytest-order";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jacg
      Luflosi
    ];
  };
}
