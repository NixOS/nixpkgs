{ lib, buildPythonPackage, fetchPypi, pythonAtLeast }:

buildPythonPackage rec {
  pname = "crashtest";
  version = "0.4.0";
  disabled = !(pythonAtLeast "3.6");

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1imwDx1OecMWkJ9Ot2O7yym1ENZfveE2Whzrk6t/pMg=";
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
