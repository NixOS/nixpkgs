{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json5";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    tag = "v${version}";
    hash = "sha256-ou4Rc50PsWtgWmD05JUU2fmZc2IRYppao5Kf0WVfYF0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json5" ];

  meta = {
    description = "Python implementation of the JSON5 data format";
    homepage = "https://github.com/dpranke/pyjson5";
    changelog = "https://github.com/dpranke/pyjson5/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
    mainProgram = "pyjson5";
  };
}
