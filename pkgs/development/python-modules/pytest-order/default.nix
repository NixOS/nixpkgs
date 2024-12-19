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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-order";
    rev = "refs/tags/v${version}";
    hash = "sha256-V1qJGkXn+HhuK5wiwkkJBEbfnv23R4x9Cv0J6ZTj5xE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-dependency
    pytest-mock
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Pytest plugin that allows you to customize the order in which your tests are run";
    homepage = "https://github.com/pytest-dev/pytest-order";
    license = licenses.mit;
    maintainers = with maintainers; [
      jacg
      Luflosi
    ];
  };
}
