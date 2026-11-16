{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  cython,
  setuptools,
  numpy,
}:
buildPythonPackage (finalAttrs: {
  pname = "daqp";
  version = "0.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QWLH9v2AJhmc19C2rlUo/IPgtugRMvnVMHFMmw0FrUs=";
  };

  # Don't try to `rmtree` to "Cleanup C-source"
  postPatch = ''
    substituteInPlace setup.py --replace-fail \
      "if daqp_src_exists:" \
      "if False:"
  '';

  sourceRoot = "${finalAttrs.src.name}/interfaces/daqp-python";

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [
    "--start-directory=test"
    "--pattern=*.py"
    "-v"
  ];

  build-system = [
    cython
    setuptools
  ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "daqp" ];

  meta = {
    description = "Dual active-set algorithm for convex quadratic programming";
    homepage = "https://github.com/darnstrom/daqp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renesat ];
  };
})
