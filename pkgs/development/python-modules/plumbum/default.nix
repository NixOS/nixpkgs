{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  mount,
  openssh,
  paramiko,
  ps,
  psutil,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "plumbum";
    tag = "v${version}";
    hash = "sha256-i99HpT/QuF9JwX92IwwOqpEVUc/1k39E7N9v9TZ4Qvg=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    typing-extensions
  ];

  optional-dependencies = {
    ssh = [ paramiko ];
  };

  nativeCheckInputs = [
    mount
    openssh
    ps
    psutil
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    export HOME=$TMP
  '';

  pytestFlags = [
    # broken in nix env
    "--deselect=tests/test_local.py::TestLocalMachine::test_local"
  ];

  meta = {
    description = "Module Shell Combinators";
    changelog = "https://github.com/tomerfiliba/plumbum/releases/tag/v${version}";
    homepage = "https://github.com/tomerfiliba/plumbum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
