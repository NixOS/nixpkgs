{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hepunits";
  version = "2.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ijNm+l1ywWrxFm7Vec2qge3SZ2rLj2of59opDO/KOwg=";
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

