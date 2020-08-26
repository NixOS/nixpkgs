{ lib, buildPythonPackage, fetchFromGitHub, fetchPypi, pythonAtLeast, pytest }:

buildPythonPackage rec {
  pname = "crashtest";
  version = "0.3.1";
  disabled = !(pythonAtLeast "3.6");

  src = fetchPypi {
    inherit pname version;
    sha256 = "42ca7b6ce88b6c7433e2ce47ea884e91ec93104a4b754998be498a8e6c3d37dd";
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
