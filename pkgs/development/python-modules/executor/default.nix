{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  isPy27,
  pythonAtLeast,
  coloredlogs,
  humanfriendly,
  property-manager,
  fasteners,
  six,
  pytestCheckHook,
  mock,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "executor";
  version = "23.2";
  format = "setuptools";

  # pipes is removed in python 3.13
  disabled = isPy27 || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-executor";
    tag = version;
    hash = "sha256-Gjv+sUtnP11cM8GMGkFzXHVx0c2XXSU56L/QwoQxINc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    coloredlogs
    humanfriendly
    property-manager
    fasteners
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    virtualenv
  ];

  # ignore impure tests
  disabledTests = [
    "option"
    "retry"
    "remote"
    "ssh"
    "foreach"
    "local_context"
    "release" # meant to be ran on ubuntu to succeed
  ];

  meta = {
    changelog = "https://github.com/xolox/python-executor/blob/${version}/CHANGELOG.rst";
    description = "Programmer friendly subprocess wrapper";
    mainProgram = "executor";
    homepage = "https://github.com/xolox/python-executor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
