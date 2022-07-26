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
  version = "0.8.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  # Tests are only available on GitHub
  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certomancer";
    rev = version;
    sha256 = "sha256-H43NlFNTwZtedHsB7c62MocwQVOi5JjVJxRcZY+Wn7Y=";
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
    substituteInPlace setup.py \
      --replace ", 'pytest-runner'" "" \
      --replace "pyhanko-certvalidator==0.19.2" "pyhanko-certvalidator==0.19.5"
  '';

  checkInputs = [
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

  pythonImportsCheck = [ "certomancer" ];

  meta = with lib; {
    description = "Quickly construct, mock & deploy PKI test configurations using simple declarative configuration";
    homepage = "https://github.com/MatthiasValvekens/certomancer";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
