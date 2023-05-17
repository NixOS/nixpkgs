 { lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylint-venv";
  version = "3.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jgosmann";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GkUdIG+Mp2/POOPJZ/vtONYrd26GB44dxh9455aWZuU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pylint_venv"
  ];

  meta = with lib; {
    description = "Module to make pylint respect virtual environments";
    homepage = "https://github.com/jgosmann/pylint-venv/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
