{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchPypi
, fetchpatch
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
  version = "3.2.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.abode";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZDdZba1oTOPaUm+r4fWC5E3ni/k8kXo6t5AWQTvfd5E=";
  };

  patches = [
    # https://github.com/jaraco/jaraco.abode/issues/19
    (fetchpatch {
      name = "specify-options-package-data.patch";
      url = "https://github.com/jaraco/jaraco.abode/commit/8deebf57162fa097243d2b280942b6b7f95174c8.patch";
      hash = "sha256-Iu2uw9D+nMdVJZyoecEkwQaJH1oSzFN/ZLXKPZPGuPk=";
    })
  ];

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
