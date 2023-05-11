{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build time
, pdm-pep517

# runtime
, packaging

# tests
, pytestCheckHook
}:

let
  pname = "findpython";
  version = "0.2.5";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4P1HO0Jl5+DnhD7Hb+rIwMRBuGlXH0Zb7+nmlZSQaf4=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "findpython"
  ];

  meta = with lib; {
    description = "A utility to find python versions on your system";
    homepage = "https://github.com/frostming/findpython";
    changelog = "https://github.com/frostming/findpython/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
