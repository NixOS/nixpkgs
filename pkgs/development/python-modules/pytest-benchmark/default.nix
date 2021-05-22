{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, py-cpuinfo
, pythonOlder
, pathlib
, statistics
}:

buildPythonPackage rec {
  pname = "pytest-benchmark";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hslzzinpwc1zqhbpllqh3sllmiyk69pcycl7ahr0rz3micgwczj";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ py-cpuinfo ] ++ lib.optionals (pythonOlder "3.4") [ pathlib statistics ];

  # TODO: fix tests
  # Since pytestCheckHook has replaced setuptoolsCheckHook,
  # tests are now found but fail.
  doCheck = false;

  meta = {
    description = "Py.test fixture for benchmarking code";
    homepage = "https://github.com/ionelmc/pytest-benchmark";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
