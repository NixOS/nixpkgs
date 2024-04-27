{ stdenv
, lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, keyring
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, playwright
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pycookiecheat";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "n8henrie";
    repo = "pycookiecheat";
    rev = "refs/tags/v${version}";
    hash = "sha256-mSc5FqMM8BICVEdSdsIny9Bnk6qCRekPk4RkBusDoVA=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "keyring"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cryptography
    keyring
  ];

  nativeCheckInputs = [
    playwright
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pycookiecheat"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Tests want to use playwright executable
    "test_no_cookies"
    "test_fake_cookie"
    "test_firefox_cookies"
    "test_load_firefox_cookie_db"
    "test_firefox_no_cookies"
    "test_firefox_get_default_profile"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_slack_config"
  ];

  meta = with lib; {
    description = "Borrow cookies from your browser's authenticated session for use in Python scripts";
    homepage = "https://github.com/n8henrie/pycookiecheat";
    changelog = "https://github.com/n8henrie/pycookiecheat/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
