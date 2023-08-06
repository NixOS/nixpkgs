{ lib
, buildPythonPackage
, fetchPypi
, portalocker
}:

buildPythonPackage rec {
  pname = "concurrent-log-handler";
  version = "0.9.24";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-APVkbG5fb8Y2VFNvO0Sqorm3SyMkXhT1JY7ZHOOdEuI=";
  };

  propagatedBuildInputs = [
    portalocker
  ];

  pythonImportsCheck = [
    "concurrent_log_handler"
  ];

  doCheck = false; # upstream has no tests

  meta = with lib; {
    description = "Python logging handler that allows multiple processes to safely write to the same log file concurrently";
    homepage = "https://pypi.org/project/concurrent-log-handler";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
