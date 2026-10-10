{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pint,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hepunits";
  version = "2.4.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-376enN8mWu6hiWNSyl61BgnhXUl6A8BGa6SpIHY/Yzc=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pint
  ];

  meta = {
    description = "Units and constants in the HEP system of units";
    homepage = "https://github.com/scikit-hep/hepunits";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
