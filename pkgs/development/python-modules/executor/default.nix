{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  coloredlogs,
  humanfriendly,
  property-manager,
  fasteners,
  six,
  pytestCheckHook,
  mock,
  virtualenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "executor";
  version = "23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-executor";
    tag = finalAttrs.version;
    hash = "sha256-Gjv+sUtnP11cM8GMGkFzXHVx0c2XXSU56L/QwoQxINc=";
  };

  patches = [
    # https://github.com/xolox/python-executor/pull/26
    (fetchpatch2 {
      name = "python313-compat.patch";
      url = "https://github.com/xolox/python-executor/commit/4c5f4b44543bfb48ad790c440d1d7d0933e12499.patch?full_index=1";
      hash = "sha256-pfWdLaREikzBaey75Tb+GiE+pUCl1h2OmsjlpzKOlno=";
    })
  ];

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
    changelog = "https://github.com/xolox/python-executor/blob/${finalAttrs.version}/CHANGELOG.rst";
    description = "Programmer friendly subprocess wrapper";
    mainProgram = "executor";
    homepage = "https://github.com/xolox/python-executor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
})
