{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tavily-cli";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tavily-ai";
    repo = "tavily-cli";
    rev = "a673275091860c8f5b77683cef545a9154da52f5";
    hash = "sha256-ToaUFis7Ofp1pvT3NK9G0ZeKVj2QmKX+QrTj6Jt8wH0=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    tavily-python
    click
    rich
    httpx
    packaging
    requests
    urllib3
    certifi
    psutil
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  # Exercises the upstream curl | sh installer in a stubbed environment that
  # relies on a full userland (grep, a controlling tty), not the build sandbox.
  disabledTestPaths = [ "tests/test_install_sh.py" ];

  pythonImportsCheck = [ "tavily_cli" ];

  meta = {
    description = "CLI and agent tools for the Tavily API";
    homepage = "https://github.com/tavily-ai/tavily-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sshine ];
    mainProgram = "tvly";
  };
})
