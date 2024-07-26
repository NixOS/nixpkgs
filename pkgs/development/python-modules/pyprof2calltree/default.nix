{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pyprof2calltree";
  version = "1.4.5";
  format = "setuptools";

  # Fetch from GitHub because the PyPi packaged version does not
  # include all test files.
  src = fetchFromGitHub {
    owner = "pwaller";
    repo = "pyprof2calltree";
    rev = "v" + version;
    sha256 = "0akighssiswfhi5285rrj37am6flg3ip17c34bayq3r8yyk1iciy";
  };

  meta = with lib; {
    description = "Help visualize profiling data from cProfile with kcachegrind and qcachegrind";
    homepage = "https://github.com/pwaller/pyprof2calltree";
    changelog = "https://github.com/pwaller/pyprof2calltree/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
