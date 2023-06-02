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
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JoshData";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-o7UREa+IBiFjmqx0p+4XJCcoHQ/R6r2RtoezEcWvgbg=";
  };

  propagatedBuildInputs = [
    dnspython
    idna
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # importing some test modules and running some tests fails with
  # dns.resolver.NoResolverConfiguration due to network sandboxing
  preCheck =
    let skipDNSResolver = testfile: "sed -i -E 's/^RESOLVER = .+//g' tests/test_${testfile}.py";
    in ''
    ${skipDNSResolver "deliverability"}
    ${skipDNSResolver "main"}
    '';

  disabledTests = [
    "test_caching_dns_resolver"
    "test_deliverability_no_records"
    "test_deliverability_found"
    "test_deliverability_fails"
    "test_deliverability_dns_timeout"
    "test_email_example_reserved_domain"
    "test_main_single_good_input"
    "test_main_single_bad_input"
    "test_main_multi_input"
    "test_validate_email__with_caching_resolver"
    "test_validate_email__with_configured_resolver"
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
