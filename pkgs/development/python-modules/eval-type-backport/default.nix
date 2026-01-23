{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:
buildPythonPackage (finalAttrs: {
  pname = "eval-type-backport";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "eval_type_backport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K+FrgRyxCbrKHcrUaHEJWlLp2i0xes3HwXPN9ucioZY=";
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
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
