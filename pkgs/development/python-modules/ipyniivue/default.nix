{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, hatchling
, hatch-jupyter-builder
, anywidget
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ipyniivue";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CvMSUvPyXxPexs0/0sa/xt65RFWtvmYZwGSMIQGvLkc=";
  };

  # We do not need the build hooks, because we do not need to
  # build any JS components; these are present already in the PyPI artifact.
  env.HATCH_BUILD_NO_HOOKS = true;

  build-system = [
    hatchling
    hatch-jupyter-builder
  ];

  dependencies = [ anywidget ];

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
