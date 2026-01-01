{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "eval-type-backport";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "eval_type_backport";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-K+FrgRyxCbrKHcrUaHEJWlLp2i0xes3HwXPN9ucioZY=";
=======
    hash = "sha256-r+JiPBcU/6li9R/CQP0CKoWJiMgky03GKrMIsmaSJEk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Like `typing._eval_type`, but lets older Python versions use newer typing features";
    homepage = "https://github.com/alexmojaki/eval_type_backport";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ PerchunPak ];
=======
    maintainers = with lib.maintainers; [ perchun ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
