{
  lib,
  buildPythonPackage,
  dnspython,
  fetchPypi,
  idna,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "email-validator";
  version = "2.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "email_validator";
    inherit version;
    hash = "sha256-n8BcN/L2z0Of9BT4/EbZF5KZdKgiRMIOsQIxumDFRCY=";
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

  meta = {
    description = "Email syntax and deliverability validation library";
    mainProgram = "email_validator";
    homepage = "https://github.com/JoshData/python-email-validator";
    changelog = "https://github.com/JoshData/python-email-validator/releases/tag/v${version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ siddharthist ];
  };
}
