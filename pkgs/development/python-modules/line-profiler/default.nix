{
  lib,
  buildPythonPackage,
  cmake,
  cython,
  fetchFromGitHub,
  ipython,
  isPyPy,
  pytestCheckHook,
  scikit-build,
  setuptools,
  typing-extensions,
  ubelt,
}:

buildPythonPackage (finalAttrs: {
  pname = "line-profiler";
  version = "5.0.2";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "pyutils";
    repo = "line_profiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GWByg1TxFWmLm6hDjaMk2kJE6VgX1kxoVT4OH3XA0GI=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    cmake
    scikit-build
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    ubelt
    ipython
  ];

  dontUseCmakeConfigure = true;

  # Remove, as it breaks some tests
  postPatch = ''
    substituteInPlace tests/test_explicit_profile.py \
      --replace-fail "env['PYTHONPATH'] = os.getcwd()" ""
  '';

  preBuild = ''
    rm -f _line_profiler.c
  '';

  preCheck = ''
    rm -r line_profiler
    export PATH=$out/bin:$PATH
  '';

  # Disabled because files are not shipped via pypi and it tries installing a subpackage via pip
  disabledTests = [
    "test_recover_cython_source"
    "test_profile_cython_source"
  ];

  pythonImportsCheck = [ "line_profiler" ];

  meta = {
    description = "Line-by-line profiler";
    homepage = "https://github.com/pyutils/line_profiler";
    changelog = "https://github.com/pyutils/line_profiler/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "kernprof";
  };
})
