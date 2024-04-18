{
  lib,
  asn1crypto,
  buildPythonPackage,
  click,
  cryptography,
  fetchFromGitHub,
  freezegun,
  jinja2,
  oscrypto,
  pyhanko-certvalidator,
  pytest-aiohttp,
  pytestCheckHook,
  python-dateutil,
  python-pkcs11,
  pythonOlder,
  pytz,
  pyyaml,
  requests,
  requests-mock,
  setuptools,
  tzlocal,
  werkzeug,
  wheel,
}:

buildPythonPackage rec {
  pname = "certomancer";
  version = "0.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certomancer";
    rev = "refs/tags/v${version}";
    hash = "sha256-c2Fq4YTHQvhxuZrpKQYZvqHIMfubbkeKV4rctELLeJU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ' "pytest-runner",' "" \
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    asn1crypto
    click
    oscrypto
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
    pkcs12 = [ cryptography ];
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
    # https://github.com/MatthiasValvekens/certomancer/issues/12
    "test_keyset_templates_in_arch"
    "test_crl"
    "test_aia_ca_issuers"
    "test_timestamp"
  ];

  pythonImportsCheck = [ "certomancer" ];

  meta = with lib; {
    description = "Quickly construct, mock & deploy PKI test configurations using simple declarative configuration";
    mainProgram = "certomancer";
    homepage = "https://github.com/MatthiasValvekens/certomancer";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
