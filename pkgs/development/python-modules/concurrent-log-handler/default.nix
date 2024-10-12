{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  portalocker,
}:

buildPythonPackage rec {
  pname = "concurrent-log-handler";
  version = "0.9.25";
  pyproject = true;

  src = fetchPypi {
    pname = "concurrent_log_handler";
    inherit version;
    hash = "sha256-HixvAhQU4hTT2sZhB4lIJ6PnjbYwGDBKTynlW6VJrCI=";
  };

  build-system = [ hatchling ];

  dependencies = [ portalocker ];

  pythonImportsCheck = [ "concurrent_log_handler" ];

  doCheck = false; # upstream has no tests

  meta = with lib; {
    description = "Python logging handler that allows multiple processes to safely write to the same log file concurrently";
    homepage = "https://github.com/Preston-Landers/concurrent-log-handler";
    license = licenses.asl20;
    maintainers = [ maintainers.bbjubjub ];
  };
}
