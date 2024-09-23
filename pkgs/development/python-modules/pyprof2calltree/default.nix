{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyprof2calltree";
  version = "1.4.5";
  pyproject = true;

  # Fetch from GitHub because the PyPi packaged version does not
  # include all test files.
  src = fetchFromGitHub {
    owner = "pwaller";
    repo = "pyprof2calltree";
    rev = "refs/tags/v${version}";
    hash = "sha256-PrIYpvcoD+zVIoOdcON41JmqzpA5FyRKhI7rqDV8cSo=";
  };

  build-system = [ setuptools ];

  meta = with lib; {
    description = "Help visualize profiling data from cProfile with kcachegrind and qcachegrind";
    mainProgram = "pyprof2calltree";
    homepage = "https://github.com/pwaller/pyprof2calltree";
    changelog = "https://github.com/pwaller/pyprof2calltree/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
