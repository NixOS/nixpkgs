{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pyprof2calltree";
  version = "1.4.4";

  # Fetch from GitHub because the PyPi packaged version does not
  # include all test files.
  src = fetchFromGitHub {
    owner = "pwaller";
    repo = "pyprof2calltree";
    rev = "v" + version;
    sha256 = "1vrip41ib7nmkwa8rjny1na1wyp7nvvgvm0h9bd21i262kbm4nqx";
  };

  meta = with lib; {
    description = "Help visualize profiling data from cProfile with kcachegrind and qcachegrind";
    homepage = https://pypi.python.org/pypi/pyprof2calltree/;
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
