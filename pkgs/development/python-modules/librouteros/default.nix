{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-xdist,
  pytest7CheckHook,
  pythonOlder,
  poetry-core,
  toml,
}:

buildPythonPackage rec {
  pname = "librouteros";
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = "librouteros";
    rev = "refs/tags/${version}";
    hash = "sha256-dbeKJ3iG0eEW+sJJoZmQXyUad6mPhIlCAdJyQZT+CCQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ toml ];

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
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
