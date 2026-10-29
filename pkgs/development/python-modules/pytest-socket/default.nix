{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-socket";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miketheman";
    repo = "pytest-socket";
    tag = finalAttrs.version;
    hash = "sha256-Z8aCucbYR6kIgrtZlITPjElwBiIW7DhAk5oTnuiEwWQ=";
  };

  nativeBuildInputs = [ uv-build ];

  buildInputs = [ pytest ];

  # pytest-socket require network for majority of tests
  doCheck = false;

  pythonImportsCheck = [ "pytest_socket" ];

  meta = {
    description = "Pytest Plugin to disable socket calls during tests";
    homepage = "https://github.com/miketheman/pytest-socket";
    changelog = "https://github.com/miketheman/pytest-socket/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
