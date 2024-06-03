{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
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
  version = "0.12.0";
  pyproject = true;

  # https://github.com/MatthiasValvekens/certomancer/issues/12
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certomancer";
    rev = "refs/tags/v${version}";
    hash = "sha256-c2Fq4YTHQvhxuZrpKQYZvqHIMfubbkeKV4rctELLeJU=";
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

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    # pyhanko_certvalidator.errors.DisallowedAlgorithmError
    "test_validate"
  ];

  pythonImportsCheck = [ "certomancer" ];

  meta = {
    description = "Quickly construct, mock & deploy PKI test configurations using simple declarative configuration";
    mainProgram = "certomancer";
    homepage = "https://github.com/MatthiasValvekens/certomancer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
