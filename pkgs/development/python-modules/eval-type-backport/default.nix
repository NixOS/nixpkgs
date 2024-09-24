{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "eval-type-backport";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "eval_type_backport";
    rev = "refs/tags/v${version}";
    hash = "sha256-EiYJQUnK10lqjyJ89KacbZ+ZZuOmkRQ9bqTFQFN2iMA=";
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
