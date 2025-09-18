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
  version = "0.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "eval_type_backport";
    tag = "v${version}";
    hash = "sha256-r+JiPBcU/6li9R/CQP0CKoWJiMgky03GKrMIsmaSJEk=";
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
    maintainers = with lib.maintainers; [ perchun ];
  };
}
