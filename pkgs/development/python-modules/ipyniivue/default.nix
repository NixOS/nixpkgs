{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, hatchling
, hatch-jupyter-builder
, ipywidgets
, jupyter-ui-poll
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ipyniivue";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vFbEV/ZMXvKZeQUR536OZQ/5uIkt4tOWcCGRPMdc34I";
  };

  nativeBuildInputs = [ hatchling hatch-jupyter-builder ];

  propagatedBuildInputs = [ ipywidgets jupyter-ui-poll ];

  nativeCheckImports = [ pytestCheckHook ];
  pythonImportsCheck = [ "ipyniivue" ];

  meta = with lib; {
    description = "Show a nifti image in a webgl 2.0 canvas within a jupyter notebook cell";
    homepage = "https://github.com/niivue/ipyniivue";
    changelog = "https://github.com/niivue/ipyniivue/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
