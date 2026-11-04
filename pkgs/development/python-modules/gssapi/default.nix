{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  decorator,

  # native dependencies
  krb5-c, # C krb5 library, not PyPI krb5

  # tests
  parameterized,
  k5test,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gssapi";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pythongssapi";
    repo = "python-gssapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LgIHMpMallfj5Or3f998jY9WvP9Ic6r5/EM5IbTuYEw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython == 3.3.0" Cython
    substituteInPlace setup.py \
      --replace-fail 'get_output(f"{kc} gssapi --prefix")' '"${lib.getDev krb5-c}"'
  '';

  env = lib.optionalAttrs (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
    GSSAPI_SUPPORT_DETECT = "false";
  };

  build-system = [
    cython
    krb5-c
    setuptools
  ];

  dependencies = [ decorator ];

  # k5test is marked as broken on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    k5test
    parameterized
    pytestCheckHook
  ];

  preCheck = ''
    mv gssapi/tests $TMPDIR/
    pushd $TMPDIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "gssapi" ];

  meta = {
    changelog = "https://github.com/pythongssapi/python-gssapi/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/pythongssapi/python-gssapi";
    description = "Python GSSAPI Wrapper";
    license = lib.licenses.mit;
  };
})
