{
  lib,
  buildPythonPackage,
  factory-boy,
  faker,
  fetchFromGitHub,
  model-bakery,
  numpy,
  polyfactory,
  pytest,
  pytest-xdist,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pytest-randomly";
    owner = "pytest-dev";
    tag = version;
    hash = "sha256-vURwJ6jN/sxuaVFEYPZxd7qaaAWtv2WTOeSkxKRzEXo=";
  };

  patches = [
    ./pytest-9.2-compat.patch
  ];

  postPatch = ''
    sed -Ei 's/(uv[-_]build)[<>=!~][^"]*/\1/' pyproject.toml
  '';

  build-system = [ uv-build ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    factory-boy
    faker
    model-bakery
    numpy
    polyfactory
    pytest-xdist
    pytestCheckHook
  ];

  # needs special invocation, copied from tox.ini
  pytestFlags = [
    "-pno:randomly"
  ];

  disabledTests = [
    # Error importing plugin "xasdlkj": No module named 'xasdlkj'
    "test_failing_import"
  ];

  pythonImportsCheck = [ "pytest_randomly" ];

  meta = {
    changelog = "https://github.com/pytest-dev/pytest-randomly/blob/${src.tag}/CHANGELOG.rst";
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
