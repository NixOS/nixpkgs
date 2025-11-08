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

let
  instrument-hooks = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "instrument-hooks";
    rev = "b003e5024d61cfb784d6ac6f3ffd7d61bf7b9ec9";
    hash = "sha256-JTSH4wOpOGJ97iV6sagiRUu8d3sKM2NJRXcB3NmozNQ=";
  };
in

buildPythonPackage rec {
  pname = "pytest-codspeed";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "pytest-codspeed";
    tag = "v${version}";
    hash = "sha256-5fdG7AEiLD3ZZzU/7zBK0+LDacTZooyDUo+FefcE4uQ=";
  };

  postPatch = ''
    pushd src/pytest_codspeed/instruments/hooks
    rmdir instrument-hooks
    ln -nsf ${instrument-hooks} instrument-hooks
    popd
  '';

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
