{ lib
, buildPythonPackage
, bx-py-utils
, colorlog
, fetchFromGitHub
, importlib-resources
, jaraco-classes
, jaraco-collections
, jaraco-itertools
, jaraco-context
, jaraco-net
, keyring
, lomond
, more-itertools
, platformdirs
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, requests-toolbelt
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco-abode";
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.abode";
    rev = "refs/tags/v${version}";
    hash = "sha256-guLgmhjFgYLRZsQ0j92NXkktZ80bwVvMUJLZeg3dgxE=";
  };

  postPatch = ''
    # https://github.com/jaraco/jaraco.abode/issues/19
    echo "graft jaraco" > MANIFEST.in

    # https://github.com/jaraco/jaraco.abode/commit/9e3e789efc96cddcaa15f920686bbeb79a7469e0
    substituteInPlace jaraco/abode/helpers/timeline.py \
      --replace "call_aside" "invoke"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
    lomond
    colorlog
    keyring
    requests-toolbelt
    jaraco-collections
    jaraco-context
    jaraco-classes
    jaraco-net
    more-itertools
    importlib-resources
    bx-py-utils
    platformdirs
    jaraco-itertools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "jaraco.abode"
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  disabledTests = [
    "_cookie_string"
    "test_cookies"
    "test_empty_cookies"
    "test_invalid_cookies"
    # Issue with the regex
    "test_camera_capture_no_control_URLs"
  ];

  meta = with lib; {
    changelog = "https://github.com/jaraco/jaraco.abode/blob/${version}/CHANGES.rst";
    homepage = "https://github.com/jaraco/jaraco.abode";
    description = "Library interfacing to the Abode home security system";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee dotlambda ];
  };
}
