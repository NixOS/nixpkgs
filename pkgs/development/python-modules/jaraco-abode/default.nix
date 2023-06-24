{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
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
, jaraco_functools
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "jaraco-abode";
  version = "5.1.0";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.abode";
    rev = "refs/tags/v${version}";
    hash = "sha256-guLgmhjFgYLRZsQ0j92NXkktZ80bwVvMUJLZeg3dgxE=";
  };

  postPatch = ''
    # https://github.com/jaraco/jaraco.abode/issues/19
    echo "graft jaraco" > MANIFEST.in
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
    jaraco_functools
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
    "test_camera_capture_no_control_URLs"
  ];

  meta = with lib; {
    changelog = "https://github.com/jaraco/jaraco.abode/blob/${src.rev}/CHANGES.rst";
    homepage = "https://github.com/jaraco/jaraco.abode";
    description = "Library interfacing to the Abode home security system";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee dotlambda ];
  };
}
