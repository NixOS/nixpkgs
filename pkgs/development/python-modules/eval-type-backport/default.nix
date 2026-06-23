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
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "eval_type_backport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ipo0atAAz0LhUwsO5Hm8fAG6lfjoKXZjF0bH7p2u63k=";
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
