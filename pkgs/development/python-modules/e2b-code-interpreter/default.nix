{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  attrs,
  e2b,
  httpx,

  # tests
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "e2b-code-interpreter";
  version = "2.9.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "e2b-dev";
    repo = "code-interpreter";
    tag = "@e2b/code-interpreter-python@${finalAttrs.version}";
    hash = "sha256-RIKbk0CKqP9KUyi/WDqPGFK3ce/033VwKJR/yJGLPvI=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [
    poetry-core
  ];

  dependencies = [
    attrs
    # Upstream requires e2b >=2.39.1,<3.0.0; enforced by pythonRuntimeDepsCheck.
    e2b
    httpx
  ];

  pythonImportsCheck = [ "e2b_code_interpreter" ];

  nativeCheckInputs = [
    pytest-asyncio
    # upstream's pytest.ini passes --numprocesses
    pytest-xdist
    pytestCheckHook
  ];

  # Everything else under tests/ drives a real sandbox and needs an API key --
  # including tests/charts, which renders the charts inside one.
  enabledTestPaths = [ "tests/test_sandbox_url.py" ];

  # Import e2b_code_interpreter from $out rather than the source tree.
  preCheck = ''
    rm -r e2b_code_interpreter
  '';

  meta = {
    description = "Stateful code execution in cloud sandboxes";
    homepage = "https://github.com/e2b-dev/code-interpreter/tree/main/python";
    changelog = "https://github.com/e2b-dev/code-interpreter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      mishushakov
    ];
  };
})
