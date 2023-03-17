{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.8.0";
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wvXhfZ2pLY7B995jMasIEWuRFa26vLpuII1G/EmpjFo=";
  };

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pyotp" ];

  meta = with lib; {
    changelog = "https://github.com/pyauth/pyotp/blob/v${version}/Changes.rst";
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyauth/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
