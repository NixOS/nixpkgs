{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-xdist,
  pytest7CheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "librouteros";
  version = "3.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = "librouteros";
    rev = "refs/tags/${version}";
    hash = "sha256-VwpZ1RY6Sul7xvWY7ZoOxZ7KgbRmKRwcVdF9e2b3f6Q=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytest-xdist
    pytest7CheckHook
  ];

  disabledTests = [
    # Disable tests which require QEMU to run
    "test_login"
    "test_long_word"
    "test_query"
    "test_add_then_remove"
    "test_add_then_update"
    "test_generator_ditch"
    # AttributeError: 'called_once_with' is not a valid assertion
    "test_rawCmd_calls_writeSentence"
  ];

  pythonImportsCheck = [ "librouteros" ];

  meta = with lib; {
    description = "Python implementation of the MikroTik RouterOS API";
    homepage = "https://librouteros.readthedocs.io/";
    changelog = "https://github.com/luqasz/librouteros/blob/${version}/CHANGELOG.rst";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
