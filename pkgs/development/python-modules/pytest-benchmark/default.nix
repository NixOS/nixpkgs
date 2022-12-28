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
  version = "3.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qc/8Epax5bPUZvhq42xSj6NUq0T4gbO5dDDS6omWBOU=";
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
