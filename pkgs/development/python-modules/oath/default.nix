{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oath";
  version = "1.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vWsg0g8sTj9TUj7pACEdynWu7KcvT1qf2NyswXX+HAs=";
  };
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oath" ];

<<<<<<< HEAD
  meta = {
    description = "Python implementation of the three main OATH specifications: HOTP, TOTP and OCRA";
    homepage = "https://github.com/bdauvergne/python-oath";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aw ];
=======
  meta = with lib; {
    description = "Python implementation of the three main OATH specifications: HOTP, TOTP and OCRA";
    homepage = "https://github.com/bdauvergne/python-oath";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aw ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
