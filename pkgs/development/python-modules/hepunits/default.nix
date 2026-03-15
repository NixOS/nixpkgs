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
  version = "2.4.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GEbnKfo+T7Nr/1me17i9LNxKvcApBoMPt1wgX9VJBes=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Units and constants in the HEP system of units";
    homepage = "https://github.com/scikit-hep/hepunits";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
