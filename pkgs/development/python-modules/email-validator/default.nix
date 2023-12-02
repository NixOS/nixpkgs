{ lib
, buildPythonPackage
, dnspython
, fetchFromGitHub
, idna
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "email-validator";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JoshData";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-58DuQslADM7glrnlSSP6TtIDTlwuS0/GK8+izatqDxI=";
  };

  propagatedBuildInputs = [
    dnspython
    idna
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # dns.resolver.NoResolverConfiguration: cannot open /etc/resolv.conf
    "tests/test_deliverability.py"
    "tests/test_main.py"
  ];

  pythonImportsCheck = [
    "email_validator"
  ];

  meta = with lib; {
    description = "Email syntax and deliverability validation library";
    homepage = "https://github.com/JoshData/python-email-validator";
    changelog = "https://github.com/JoshData/python-email-validator/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
  };
}
