{ lib
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
}:

buildPythonPackage rec {
  pname = "certomancer";
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

  propagatedBuildInputs = [
    asn1crypto
    click
    oscrypto
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

  disabledTests = [
    # pyhanko_certvalidator.errors.DisallowedAlgorithmError
    "test_validate"
  ];

  pythonImportsCheck = [ "certomancer" ];

  meta = with lib; {
    description = "Quickly construct, mock & deploy PKI test configurations using simple declarative configuration";
    homepage = "https://github.com/MatthiasValvekens/certomancer";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
