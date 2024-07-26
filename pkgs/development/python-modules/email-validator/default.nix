{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dnspython,
  idna,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "email-validator";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "JoshData";
    repo = "python-email-validator";
    rev = "refs/tags/v${version}";
    hash = "sha256-G6aiRLKR50XExLHo5bCPV2m70G71w4pFvgC6+j8NNGI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dnspython
    idna
  ];

  pythonImportsCheck = [ "email_validator" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # dns.resolver.NoResolverConfiguration: cannot open /etc/resolv.conf
    "tests/test_deliverability.py"
    "tests/test_main.py"
  ];

  meta = {
    description = "Email syntax and deliverability validation library";
    mainProgram = "email_validator";
    homepage = "https://github.com/JoshData/python-email-validator";
    changelog = "https://github.com/JoshData/python-email-validator/releases/tag/v${version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ siddharthist ];
  };
}
