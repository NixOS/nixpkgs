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
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ms+N/m33zqO0qgtQykOI++eCkDPf50qf8lbi+tO5ae0=";
  };

  # Don't try to `rmtree` to "Cleanup C-source"
  postPatch = ''
    substituteInPlace setup.py --replace-fail \
      "if daqp_src_exists:" \
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
