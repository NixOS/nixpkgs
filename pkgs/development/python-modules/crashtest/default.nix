{ lib, buildPythonPackage, fetchPypi, pythonAtLeast }:

buildPythonPackage rec {
  pname = "crashtest";
  version = "0.4.1";
  disabled = !(pythonAtLeast "3.6");

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gNex8xbr+9Qp9kgHbWJ1yHe6MLpIl53kGRcUp1Jm8M4=";
  };

  # has tests, but only on GitHub, however the pyproject build fails for me
  pythonImportsCheck = [
    "crashtest.frame"
    "crashtest.inspector"
  ];

  meta = with lib; {
    homepage = "https://github.com/sdispater/crashtest";
    description = "Manage Python errors with ease";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
