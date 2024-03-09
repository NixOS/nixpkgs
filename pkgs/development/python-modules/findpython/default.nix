{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build time
, pdm-backend

# runtime
, packaging

# tests
, pytestCheckHook
}:

let
  pname = "findpython";
  version = "0.4.1";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-19AUVYaBs3YdV6WyNCpxOovzAvbB/J2Z+Budi9FoGwQ=";
  };

  nativeBuildInputs = [
    pdm-backend
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
