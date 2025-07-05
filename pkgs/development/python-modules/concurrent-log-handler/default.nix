{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  portalocker,
}:

buildPythonPackage rec {
  pname = "concurrent-log-handler";
  version = "0.9.26";
  pyproject = true;

  src = fetchPypi {
    pname = "concurrent_log_handler";
    inherit version;
    hash = "sha256-jyK/eXJKAVK56X2cLc9OyzOWB8gL8xL2gGYHAkMAa0k=";
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
