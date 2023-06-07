{ lib
, buildPythonPackage
, fetchPypi
, portalocker
}:

buildPythonPackage rec {
  pname = "concurrent-log-handler";
  version = "0.9.22";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+PnlhCkrnzpLR3VwGP3xr8i/lynxiKW2dQrNih5+P8k=";
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
