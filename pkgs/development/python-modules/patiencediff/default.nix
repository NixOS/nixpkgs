{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.15";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "patiencediff";
    tag = "v${version}";
    hash = "sha256-SFu1oN1yE9tKeBgWhgWjDpR31AptGrls0D5kKQed+HI=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "patiencediff" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "C implementation of patiencediff algorithm for Python";
    mainProgram = "patiencediff";
    homepage = "https://github.com/breezy-team/patiencediff";
    changelog = "https://github.com/breezy-team/patiencediff/releases/tag/v${version}";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ wildsebastian ];
=======
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wildsebastian ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
