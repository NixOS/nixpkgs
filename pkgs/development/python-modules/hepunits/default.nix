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
  version = "2.4.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iPpXyfNUWdam7iYYunPCFUxImjLiHVJbZ9qAYqIkLls=";
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
