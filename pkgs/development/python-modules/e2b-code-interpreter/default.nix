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
}:

buildPythonPackage rec {
  pname = "e2b-code-interpreter";
  inherit (e2b) version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "e2b-dev";
    repo = "code-interpreter";
    tag = "@e2b/code-interpreter-python@${version}";
    hash = "sha256-a2rc7BtV+qwtqlB+JtLCs0BKN15yfwmG3XWWO8we2LA=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [
    poetry-core
  ];

  dependencies = [
    attrs
    e2b
    httpx
  ];

  pythonImportsCheck = [ "e2b_code_interpreter" ];

  # Tests require an API key
  # e2b.exceptions.AuthenticationException: API key is required, please visit the Team tab at https://e2b.dev/dashboard to get your API key.
  doCheck = false;

  meta = {
    description = "E2B Code Interpreter - Stateful code execution";
    homepage = "https://github.com/e2b-dev/code-interpreter/tree/main/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
