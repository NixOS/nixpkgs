{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core_3,
  jinxed,
  wcwidth,
  pytest-codspeed,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "blessed";
  version = "1.52";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jquast";
    repo = "blessed";
    tag = finalAttrs.version;
    hash = "sha256-pAa6AY9lWUbjjGF0v0+7ChfCDxwNQFDV7WM7P5rfLVQ=";
  };

  build-system = [ flit-core_3 ];

  dependencies = [
    jinxed
    wcwidth
  ];

  nativeCheckInputs = [
    pytest-codspeed
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fail with several AssertionError
    "tests/test_sixel.py"
  ];

  meta = {
    homepage = "https://github.com/jquast/blessed";
    changelog = "https://github.com/jquast/blessed/releases/tag/${finalAttrs.src.tag}";
    description = "Thin, practical wrapper around terminal capabilities in Python";
    maintainers = with lib.maintainers; [ eqyiel ];
    license = lib.licenses.mit;
  };
})
