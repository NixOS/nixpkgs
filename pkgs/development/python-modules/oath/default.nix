{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oath";
  version = "1.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DFxT7SW1LvYh18CPNZwhIH/i42qJ34s80m+1S0/2E7g=";
  };
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oath" ];

  meta = {
    description = "Python implementation of the three main OATH specifications: HOTP, TOTP and OCRA";
    homepage = "https://github.com/bdauvergne/python-oath";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aw ];
  };
}
