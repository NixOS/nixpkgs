{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hepunits";
  version = "2.3.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z9fMd81U1ytpwmpo5e+teEK29o+ovGJ7uQ5BF3q+aUU=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Units and constants in the HEP system of units";
    homepage = "https://github.com/scikit-hep/hepunits";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}

