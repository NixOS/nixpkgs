{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyspellchecker";
<<<<<<< HEAD
  version = "0.8.4";
=======
  version = "0.8.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyspellchecker";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xUCfRI7GcwH7mC8IDX4HCHtKyuOnOZx+kxPRm89X87w=";
=======
    hash = "sha256-cfYtUOXO4xzO2CYYhWMv3o40iw5/+nvA8MAzJn6LPlQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Pure python spell checking";
    homepage = "https://github.com/barrust/pyspellchecker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
=======
  meta = with lib; {
    description = "Pure python spell checking";
    homepage = "https://github.com/barrust/pyspellchecker";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
