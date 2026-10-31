{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  uv-build,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-socket";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miketheman";
    repo = "pytest-socket";
    tag = version;
    hash = "sha256-Z8aCucbYR6kIgrtZlITPjElwBiIW7DhAk5oTnuiEwWQ=";
  };

  patches = [
    # allow uv-build 0.13
    (fetchpatch {
      url = "https://github.com/miketheman/pytest-socket/commit/e3ed717f36fe4794adc50712873e7c33fd43a581.patch";
      hash = "sha256-MVuXAUscU/e4FdASdITN6HH2yTacBingUrfi2vvO1yQ=";
      excludes = [ ".github/workflows/codspeed.yml" ];
    })
  ];

  nativeBuildInputs = [ uv-build ];

  buildInputs = [ pytest ];

  # pytest-socket require network for majority of tests
  doCheck = false;

  pythonImportsCheck = [ "pytest_socket" ];

  meta = {
    description = "Pytest Plugin to disable socket calls during tests";
    homepage = "https://github.com/miketheman/pytest-socket";
    changelog = "https://github.com/miketheman/pytest-socket/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
