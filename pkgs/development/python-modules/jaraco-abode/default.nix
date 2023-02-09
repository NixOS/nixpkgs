{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchPypi
, setuptools
, setuptools-scm
, requests
, lomond
, colorlog
, keyring
, requests-toolbelt
, jaraco_collections
, jaraco-context
, jaraco_classes
, jaraco-net
, more-itertools
, importlib-resources
, bx-py-utils
, platformdirs
, jaraco_itertools
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "jaraco-abode";
  version = "3.3.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.abode";
    rev = "refs/tags/v${version}";
    hash = "sha256-LnbWzIST+GMtdsHDKg67WWt9GmHUcSuGZ5Spei3nEio=";
  };

  postPatch = ''
    # https://github.com/jaraco/jaraco.abode/issues/19
    echo "graft jaraco" > MANIFEST.in
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    requests
    lomond
    colorlog
    keyring
    requests-toolbelt
    jaraco_collections
    jaraco-context
    jaraco_classes
    jaraco-net
    more-itertools
    importlib-resources
    bx-py-utils
    platformdirs
    jaraco_itertools
  ];

  pythonImportsCheck = [ "jaraco.abode" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  disabledTests = [
    "_cookie_string"
    "test_cookies"
    "test_empty_cookies"
    "test_invalid_cookies"
  ];

  meta = with lib; {
    homepage = "https://github.com/jaraco/jaraco.abode";
    description = "Library interfacing to the Abode home security system";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee dotlambda ];
  };
}
