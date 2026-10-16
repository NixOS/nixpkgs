{
  lib,
  python3,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "taskhound";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "1r0BIT";
    repo = "TaskHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OVCHdhfMkeFUgdvVY6uMBqWpJNIHE4cHFzy1XstvnyU=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    bhopengraph
    dnspython
    impacket
    ldap3
    neo4j
    pycryptodome
    requests
    rich
    rich-argparse
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Flaky timing-dependent test
    "test_rate_limit_accuracy"
    "test_parallel_mode"
  ];

  pythonImportsCheck = [ "taskhound" ];

  meta = {
    description = "Tool to enumerate privileged Scheduled Tasks on Remote Systems";
    homepage = "https://github.com/1r0BIT/TaskHound";
    changelog = "https://github.com/1r0BIT/TaskHound/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "taskhound";
  };
})
