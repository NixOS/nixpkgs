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
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "email_validator";
    inherit version;
    hash = "sha256-IApwaAugiQS+bR7vcpIFzA1odjQ5mlkk2EJTPvuCS4Q=";
  };

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Email syntax and deliverability validation library";
    mainProgram = "email_validator";
    homepage = "https://github.com/JoshData/python-email-validator";
    changelog = "https://github.com/JoshData/python-email-validator/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
  };
}
