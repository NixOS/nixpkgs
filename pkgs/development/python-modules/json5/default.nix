{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json5";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    tag = "v${version}";
    hash = "sha256-ou4Rc50PsWtgWmD05JUU2fmZc2IRYppao5Kf0WVfYF0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json5" ];

  meta = with lib; {
    description = "Python implementation of the JSON5 data format";
    homepage = "https://github.com/dpranke/pyjson5";
    changelog = "https://github.com/dpranke/pyjson5/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
    mainProgram = "pyjson5";
  };
}
