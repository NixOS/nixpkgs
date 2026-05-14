{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "persisting-theory";
  version = "1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D4QPoiJHvKpRQJTafzsmxgI1lCmrEtLNiL4GtJozYpA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "persisting_theory" ];

  meta = {
    homepage = "https://code.agate.blue/agate/persisting-theory";
    description = "Automate data discovering and access inside a list of packages";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mmai ];
  };
}
