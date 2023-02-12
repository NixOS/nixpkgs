{ lib
, buildPythonPackage
, fetchFromGitHub
, pathlib
, py-cpuinfo
, pytest
, pythonOlder
, statistics
}:

buildPythonPackage rec {
  pname = "pytest-benchmark";
  version = "4.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f9Ty4+5PycraxoLUSa9JFusV5Cot6bBWKfOGHZIRR3o=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    py-cpuinfo
  ] ++ lib.optionals (pythonOlder "3.4") [
    pathlib
    statistics
  ];

  # Circular dependency
  doCheck = false;

  pythonImportsCheck = [
    "pytest_benchmark"
  ];

  meta = with lib; {
    description = "Pytest fixture for benchmarking code";
    homepage = "https://github.com/ionelmc/pytest-benchmark";
    license = licenses.bsd2;
    maintainers = with maintainers; [ costrouc ];
  };
}
