{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-socket";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miketheman";
    repo = "pytest-socket";
    tag = version;
    hash = "sha256-UFUh0FhIEakAY1NZQD6hFY7wnnPs2NjjsfionIg0jRs=";
  };

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
