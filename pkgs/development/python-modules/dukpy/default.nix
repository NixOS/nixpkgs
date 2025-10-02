{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  mutf8,
  webassets,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "dukpy";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "dukpy";
    tag = version;
    hash = "sha256-5+SdGHYBron6EwpCf5ByaK8KuqQXhvN73wQUptvgPzc=";
  };

  postPatch = ''
    substituteInPlace tests/test_webassets_filter.py \
      --replace-fail "class PyTestTemp" "class _Temp" \
      --replace-fail "PyTestTemp" "Temp"
  '';

  build-system = [ setuptools ];

  dependencies = [ mutf8 ];

  optional-dependencies = {
    webassets = [ webassets ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ]
  ++ optional-dependencies.webassets;

  disabledTests = [ "test_installer" ];

  preCheck = ''
    rm -r dukpy
  '';

  pythonImportsCheck = [ "dukpy" ];

  meta = {
    description = "Simple JavaScript interpreter for Python";
    homepage = "https://github.com/amol-/dukpy";
    changelog = "https://github.com/amol-/dukpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ruby0b ];
    mainProgram = "dukpy";
    # error: 'TARGET_OS_BRIDGE' is not defined, evaluates to 0 [-Werror,-Wundef-prefix=TARGET_OS_]
    # https://github.com/amol-/dukpy/issues/82
    broken = stdenv.cc.isClang;
  };
}
