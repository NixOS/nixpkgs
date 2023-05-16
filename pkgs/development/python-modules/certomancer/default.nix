{ lib
<<<<<<< HEAD
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
=======
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, asn1crypto
, click
, oscrypto
, pyyaml
, python-dateutil
, tzlocal
, pytest-aiohttp
, pytz
, freezegun
, jinja2
, pyhanko-certvalidator
, requests
, requests-mock
, werkzeug
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "certomancer";
<<<<<<< HEAD
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

=======
  version = "0.9.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  # Tests are only available on GitHub
  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certomancer";
    rev = version;
    sha256 = "4v2e46ZrzhKXpMULj0vmDRoLOypi030eaADAYjLMg5M=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    asn1crypto
    click
    oscrypto
<<<<<<< HEAD
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
=======
    pyyaml
    python-dateutil
    tzlocal
  ];

  postPatch = ''
    substituteInPlace setup.py --replace ", 'pytest-runner'" ""
  '';

  nativeCheckInputs = [
    freezegun
    jinja2
    pyhanko-certvalidator
    pytest-aiohttp
    pytz
    requests
    requests-mock
    werkzeug
    pytestCheckHook
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabledTests = [
    # pyhanko_certvalidator.errors.DisallowedAlgorithmError
    "test_validate"
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "certomancer"
  ];
=======
  pythonImportsCheck = [ "certomancer" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Quickly construct, mock & deploy PKI test configurations using simple declarative configuration";
    homepage = "https://github.com/MatthiasValvekens/certomancer";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
