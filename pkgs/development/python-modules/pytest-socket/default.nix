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
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miketheman";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-RPHpqknjpuAMXYg4nFOtLp8CXh10/w0RuO/bseTBN5o=";
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
    maintainers = with maintainers; [ ];
  };
}
