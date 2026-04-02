{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.9.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NGtmQuDb3eO0/1qTC2ZMqCq/oRY1btSMxCx9ZZDTb2M=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyotp" ];

  meta = {
    changelog = "https://github.com/pyauth/pyotp/blob/v${version}/Changes.rst";
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyauth/pyotp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
