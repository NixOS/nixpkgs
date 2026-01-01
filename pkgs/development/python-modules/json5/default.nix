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
<<<<<<< HEAD
  version = "0.12.1";
=======
  version = "0.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ou4Rc50PsWtgWmD05JUU2fmZc2IRYppao5Kf0WVfYF0=";
=======
    hash = "sha256-xBErTbC/cw+1bAVPIyN0+0aPmWblNtnsbIKEZ+XIyUQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json5" ];

<<<<<<< HEAD
  meta = {
    description = "Python implementation of the JSON5 data format";
    homepage = "https://github.com/dpranke/pyjson5";
    changelog = "https://github.com/dpranke/pyjson5/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
=======
  meta = with lib; {
    description = "Python implementation of the JSON5 data format";
    homepage = "https://github.com/dpranke/pyjson5";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pyjson5";
  };
}
