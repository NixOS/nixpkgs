{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  cython,
  krb5,
  setuptools,

  # dependencies
  decorator,

  # native dependencies
  GSS,

  # tests
  parameterized,
  k5test,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gssapi";
  version = "1.8.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pythongssapi";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-H1JfdvxJvX5dmC9aTqIOkjAqFEL44KoUXEhoYj2uRY8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'get_output(f"{kc} gssapi --prefix")' '"${lib.getDev krb5}"'
  '';

  env = lib.optionalAttrs (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
    GSSAPI_SUPPORT_DETECT = "false";
  };

  build-system = [
    cython
    krb5
    setuptools
  ];

  dependencies = [ decorator ];

  buildInputs = lib.optionals stdenv.isDarwin [ GSS ];

  # k5test is marked as broken on darwin
  doCheck = !stdenv.isDarwin;

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

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/gssapi";
    description = "Python GSSAPI Wrapper";
    license = licenses.mit;
  };
}
