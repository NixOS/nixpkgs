{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-socket";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miketheman";
    repo = "pytest-socket";
    tag = version;
    hash = "sha256-19YF3q85maCVdVg2HOOPbN45RNjBf6kiFAhLut8B2tQ=";
  };

  nativeBuildInputs = [ poetry-core ];

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
