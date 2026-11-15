{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycparser";
  version = "3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eliben";
    repo = "pycparser";
    tag = "release_v${finalAttrs.version}";
    hash = "sha256-4FV6EYWFisA0nQaLDJVXLuPG5ttmP37lKACL+aWPtlM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pycparser" ];

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    substituteInPlace examples/using_gcc_E_libc.py \
      --replace-fail "'gcc'" "'${stdenv.cc.targetPrefix}cc'"
  '';
  unittestFlags = [
    "--start-directory=tests"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "release_v";
  };

  meta = {
    changelog = "https://github.com/eliben/pycparser/releases/tag/${finalAttrs.src.tag}";
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
