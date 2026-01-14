{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eliben";
    repo = "pycparser";
    tag = "release_v${version}";
    hash = "sha256-dkteM8VizYf9ZLPOe8od5CZgg7a3fs4Hy+t8bGLV/GI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pycparser" ];

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    substituteInPlace examples/using_gcc_E_libc.py \
      --replace-fail "'gcc'" "'${stdenv.cc.targetPrefix}cc'"
  '';
  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "release_v";
  };

  meta = {
    changelog = "https://github.com/eliben/pycparser/releases/tag/${src.tag}";
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
