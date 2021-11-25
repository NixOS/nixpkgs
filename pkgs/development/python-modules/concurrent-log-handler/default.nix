{ lib
, buildPythonPackage
, fetchPypi
, portalocker
}:

buildPythonPackage rec {
  pname = "concurrent-log-handler";
  version = "0.9.19";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sS95q+0/lBIcJc6cJM21fYiSguxv9h9VNasgaNw31Ak=";
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
    homepage = "https://www.chia.net/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
