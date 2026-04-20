{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "taskhound";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "1r0BIT";
    repo = "TaskHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qQ1OpJCgMcRKGkZCRjLiUO+u4SSIA/qExzq2K7m7BD8=";
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
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
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
