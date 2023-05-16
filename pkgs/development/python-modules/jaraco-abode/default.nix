{ lib
, buildPythonPackage
<<<<<<< HEAD
, bx-py-utils
, colorlog
, fetchFromGitHub
, fetchPypi
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jaraco-abode";
<<<<<<< HEAD
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

=======
  version = "5.0.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.abode";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-guLgmhjFgYLRZsQ0j92NXkktZ80bwVvMUJLZeg3dgxE=";
=======
    hash = "sha256-vKlvZrgRKv2C43JLfl4Wum4Icz9yOKEaB6qKapZ0rwQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    jaraco-collections
    jaraco-context
    jaraco-classes
=======
    jaraco_collections
    jaraco-context
    jaraco_classes
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    jaraco-net
    more-itertools
    importlib-resources
    bx-py-utils
    platformdirs
<<<<<<< HEAD
    jaraco-itertools
  ];

=======
    jaraco_itertools
  ];

  pythonImportsCheck = [ "jaraco.abode" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "jaraco.abode"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = ''
    export HOME=$TEMP
  '';

  disabledTests = [
    "_cookie_string"
    "test_cookies"
    "test_empty_cookies"
    "test_invalid_cookies"
<<<<<<< HEAD
    # Issue with the regex
    "test_camera_capture_no_control_URLs"
  ];

  meta = with lib; {
    changelog = "https://github.com/jaraco/jaraco.abode/blob/${version}/CHANGES.rst";
=======
  ];

  meta = with lib; {
    changelog = "https://github.com/jaraco/jaraco.abode/blob/${src.rev}/CHANGES.rst";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/jaraco/jaraco.abode";
    description = "Library interfacing to the Abode home security system";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee dotlambda ];
  };
}
