{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest
, pythonOlder
, setuptoolsBuildHook
}:

buildPythonPackage rec {
  pname = "pytest-socket";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miketheman";
    repo = pname;
    rev = version;
    hash = "sha256-HdGkpIHFsoAG2+8UyL9jSb3Dm8bWkYzREdY3i15ls/Q=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  # pytest-socket require network for majority of tests
  doCheck = false;

  pythonImportsCheck = [
    "pytest_socket"
  ];

  meta = with lib; {
    description = "Pytest Plugin to disable socket calls during tests";
    homepage = "https://github.com/miketheman/pytest-socket";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
