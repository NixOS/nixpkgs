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
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UakuHHsz4LXDfI7+VT5TO+jg90gpgu3lTJL8RGhtODQ=";
  };

  # Don't try to `rmtree` to "Cleanup C-source"
  # TODO: to update on next release, master already has `if daqp_src_exists:`
  postPatch = ''
    substituteInPlace setup.py --replace-fail \
      "if src_path.exists():" \
      "if False:"
  '';

  sourceRoot = "${finalAttrs.src.name}/interfaces/daqp-python";

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "test"
    "-p"
    "'*.py'"
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
