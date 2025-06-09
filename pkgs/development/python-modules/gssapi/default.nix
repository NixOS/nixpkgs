{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
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

buildPythonPackage rec {
  pname = "gssapi";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pythongssapi";
    repo = "python-${pname}";
    tag = "v${version}";
    hash = "sha256-Y53HoLcamoFIrwZtNcL1BOrzBjRD09mT3AiS0QUT7dY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'get_output(f"{kc} gssapi --prefix")' '"${lib.getDev krb5-c}"'
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

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/gssapi";
    description = "Python GSSAPI Wrapper";
    license = licenses.mit;
  };
}
