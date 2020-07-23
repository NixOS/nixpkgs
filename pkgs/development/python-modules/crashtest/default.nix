{ lib, buildPythonPackage, fetchFromGitHub, fetchPypi, pythonAtLeast, pytest }:

buildPythonPackage rec {
  pname = "crashtest";
  version = "0.3.0";
  disabled = !(pythonAtLeast "3.6");

  src = fetchPypi {
    inherit pname version;
    sha256 = "056zzbznl3xfnbblfci8lvcam3h7k7va68vi6asrm4q0ck4nrh79";
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
