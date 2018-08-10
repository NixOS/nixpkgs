{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestrunner
, pytest
, py-cpuinfo
, pythonOlder
, pathlib
, statistics
}:

buildPythonPackage rec {
  pname = "pytest-benchmark";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ch079dlc6c9ag74dh4dg6plkmh0h8kn78ari3fgadc75bald71m";
  };

  propagatedBuildInputs = [ pytest py-cpuinfo ] ++ lib.optional (pythonOlder "3.4") [ pathlib statistics ];

  meta = {
    description = "Py.test fixture for benchmarking code";
    homepage = https://github.com/ionelmc/pytest-benchmark;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
