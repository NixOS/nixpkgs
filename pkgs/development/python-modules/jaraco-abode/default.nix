{
  lib,
  buildPythonPackage,
  bx-py-utils,
  colorlog,
  fetchFromGitHub,
  importlib-resources,
  jaraco-classes,
  jaraco-collections,
  jaraco-itertools,
  jaraco-context,
  jaraco-functools,
  jaraco-net,
  keyring,
  lomond,
  more-itertools,
  platformdirs,
  pytest-responses,
  pytestCheckHook,
  requests,
  requests-toolbelt,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "jaraco-abode";
  version = "6.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.abode";
    tag = "v${version}";
    hash = "sha256-nnnVtNXQ7Sa4wXl0ay3OyjvOq2j90pTwhK24WR8mrBo=";
  };

  postPatch = ''
    sed -i "/coherent\.licensed/d" pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
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
    jaraco-functools
  ];

  nativeCheckInputs = [
    pytest-responses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jaraco.abode" ];

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

  meta = {
    changelog = "https://github.com/jaraco/jaraco.abode/blob/${src.tag}/NEWS.rst";
    homepage = "https://github.com/jaraco/jaraco.abode";
    description = "Library interfacing to the Abode home security system";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jamiemagee
      dotlambda
    ];
  };
}
