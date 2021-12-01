{ lib
, buildPythonPackage
, fetchFromGitHub
, dnspython
, idna
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "email-validator";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "JoshData";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "19n6p75m96kwg38bpfsa7ksj26aki02p5pr5f36q8wv3af84s61c";
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
    homepage    = "https://github.com/JoshData/python-email-validator";
    license     = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
    platforms   = platforms.unix;
  };
}
