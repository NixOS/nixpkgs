{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hepunits";
  version = "2.3.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lDTNLWpyLJSenp4ivQtZWH9pAlvTc1blxwY18bNwNtg=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Units and constants in the HEP system of units";
    homepage = "https://github.com/scikit-hep/hepunits";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
