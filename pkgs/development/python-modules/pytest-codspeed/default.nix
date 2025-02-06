{
  lib,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  filelock,
  hatchling,
  importlib-metadata,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-xdist,
  pytest,
  pytestCheckHook,
  rich,
  semver,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-codspeed";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "pytest-codspeed";
    tag = "v${version}";
    hash = "sha256-HtjfXA5Ifs2ytheHOb0HUM62foBYFEMwsV4h9lTNd38=";
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  dependencies = [
    cffi
    filelock
    importlib-metadata
    rich
    setuptools
  ];

  optional-dependencies = {
    compat = [
      pytest-benchmark
      pytest-xdist
    ];
  };

  nativeCheckInputs = [
    semver
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_codspeed" ];

  meta = {
    description = "Pytest plugin to create CodSpeed benchmarks";
    homepage = "https://github.com/CodSpeedHQ/pytest-codspeed";
    changelog = "https://github.com/CodSpeedHQ/pytest-codspeed/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
