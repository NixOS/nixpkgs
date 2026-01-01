{
  lib,
  buildPythonPackage,
  dnspython,
  fetchPypi,
  idna,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "email-validator";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "email_validator";
    inherit version;
    hash = "sha256-y2kPNExhenFPIuZq53FEWhzrRoIRUt+OFlxfmjZFgrc=";
  };

  dependencies = [
    dnspython
    idna
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # dns.resolver.NoResolverConfiguration: cannot open /etc/resolv.conf
    "tests/test_deliverability.py"
    "tests/test_main.py"
  ];

  pythonImportsCheck = [ "email_validator" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Email syntax and deliverability validation library";
    mainProgram = "email_validator";
    homepage = "https://github.com/JoshData/python-email-validator";
    changelog = "https://github.com/JoshData/python-email-validator/releases/tag/v${version}";
<<<<<<< HEAD
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ siddharthist ];
=======
    license = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
