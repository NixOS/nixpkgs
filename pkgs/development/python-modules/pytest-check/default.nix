{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "2.1.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AbN/1wPaD6ZntwF68fBGDHRKhfHuh2de4+D5Ssw98XI=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}
