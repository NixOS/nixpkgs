{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  # build-system
  setuptools,
  wheel,
  # dependencies
  asn1crypto,
  click,
  cryptography,
  python-dateutil,
  pyyaml,
  tzlocal,
  # optional-dependencies
  requests-mock,
  jinja2,
  werkzeug,
  python-pkcs11,
  # nativeCheckInputs
  freezegun,
  pyhanko-certvalidator,
  pytest-aiohttp,
  pytestCheckHook,
  pytz,
  requests,
}:

buildPythonPackage rec {
  pname = "certomancer";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certomancer";
    tag = "v${version}";
    hash = "sha256-2/qTTN/UuSMHjkSsOs/KbfzKLBjJSLHY51XtgQ6x1Wo=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    asn1crypto
    click
    cryptography
    python-dateutil
    pyyaml
    tzlocal
  ];

  optional-dependencies = {
    requests-mocker = [ requests-mock ];
    web-api = [
      jinja2
      werkzeug
    ];
    pkcs11 = [ python-pkcs11 ];
  };

  nativeCheckInputs = [
    freezegun
    pyhanko-certvalidator
    pytest-aiohttp
    pytestCheckHook
    pytz
    requests
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "certomancer" ];

  meta = {
    description = "Quickly construct, mock & deploy PKI test configurations using simple declarative configuration";
    mainProgram = "certomancer";
    homepage = "https://github.com/MatthiasValvekens/certomancer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
