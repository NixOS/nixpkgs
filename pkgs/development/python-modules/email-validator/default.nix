{ lib
, buildPythonPackage
, fetchFromGitHub
, dnspython
, idna
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "email-validator";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "JoshData";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-mflUF2ZKYhCiQEoG+fKI+K266dukuSzG9cyg6gwBcTo=";
  };

  propagatedBuildInputs = [
    dnspython
    idna
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # fails with dns.resolver.NoResolverConfiguration due to network sandboxing
    "test_deliverability_no_records"
    "test_deliverability_found"
    "test_deliverability_fails"
    "test_deliverability_dns_timeout"
    "test_email_example_reserved_domain"
    "test_main_single_good_input"
    "test_main_multi_input"
    "test_main_input_shim"
    "test_validate_email__with_caching_resolver"
    "test_validate_email__with_configured_resolver"
  ];

  pythonImportsCheck = [
    "email_validator"
  ];

  meta = with lib; {
    description = "A robust email syntax and deliverability validation library";
    homepage    = "https://github.com/JoshData/python-email-validator";
    changelog   = "https://github.com/JoshData/python-email-validator/releases/tag/v${version}";
    license     = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
  };
}
