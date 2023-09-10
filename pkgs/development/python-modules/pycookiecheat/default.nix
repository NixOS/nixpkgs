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
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "n8henrie";
    repo = "pycookiecheat";
    rev = "refs/tags/v${version}";
    hash = "sha256-3I7iw/dwF4lRqmVM3OR402InZCFoV9gzKpRQrx4F9KA=";
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

  disabledTests = [
    # Tests want to use playwright executable
    "test_no_cookies"
    "test_fake_cookie"
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
