{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "importmagic";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O25fBjkVMJHzdJpBtx7ifiNOGkkc929hGu8Q220Uoso=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "importmagic" ];

  meta = {
    description = "Python Import Magic - automagically add, remove and manage imports";
    homepage = "https://github.com/alecthomas/importmagic";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ onny ];
  };
}
