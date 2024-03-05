{ lib
, asn1crypto
, buildPythonPackage
, click
, cryptography
, fetchFromGitHub
, freezegun
, jinja2
, oscrypto
, pyhanko-certvalidator
, pytest-aiohttp
, pytestCheckHook
, python-dateutil
, python-pkcs11
, pythonOlder
, pytz
, pyyaml
, requests
, requests-mock
, setuptools
, tzlocal
, werkzeug
, wheel
}:

buildPythonPackage rec {
  pname = "certomancer";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certomancer";
    rev = "refs/tags/v${version}";
    hash = "sha256-UQV0Tk4C5b5iBZ34Je59gK2dLTaJusnpxdyNicIh2Q8=";
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
    requests-mocker = [
      requests-mock
    ];
    web-api = [
      jinja2
      werkzeug
    ];
    pkcs12 = [
      cryptography
    ];
    pkcs11 = [
      python-pkcs11
    ];
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

  pythonImportsCheck = [
    "certomancer"
  ];

  meta = with lib; {
    description = "Quickly construct, mock & deploy PKI test configurations using simple declarative configuration";
    homepage = "https://github.com/MatthiasValvekens/certomancer";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
