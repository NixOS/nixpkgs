{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build time
  pdm-backend,

  # runtime
  packaging,
  platformdirs,

  # tests
  pytestCheckHook,
}:

let
  pname = "findpython";
  version = "0.7.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nynmo9q9t18rOclJdywO0m6rFTCABmafNHjNqw2GfHg=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    packaging
    platformdirs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "findpython" ];

  meta = with lib; {
    description = "Utility to find python versions on your system";
    mainProgram = "findpython";
    homepage = "https://github.com/frostming/findpython";
    changelog = "https://github.com/frostming/findpython/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
