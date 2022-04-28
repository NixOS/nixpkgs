{ lib
, buildPythonPackage
, fetchFromGitHub
, dnspython
, idna
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "email-validator";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JoshData";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "sha256-2rwTQWYz49ONRZc0UK1VpnheSlux29nz6K3jBEbMw6w=";
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
    description = "A robust email syntax and deliverability validation library for Python 2.x/3.x.";
    homepage = "https://github.com/JoshData/python-email-validator";
    license = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.unix;
  };
}
