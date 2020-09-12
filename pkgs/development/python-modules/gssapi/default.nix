{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, six
, enum34
, decorator
, nose
, krb5Full
, darwin
, isPy27
, parameterized
, shouldbe
, cython
, python
, k5test
}:

buildPythonPackage rec {
  pname = "gssapi";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "pythongssapi";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "195x3zqzyv491i9hf7l4asmic5pb2w3l1r7bps89651wkb3mrz1l";
  };

  # It's used to locate headers
  postPatch = ''
    substituteInPlace setup.py \
      --replace "get_output('krb5-config gssapi --prefix')" "'${lib.getDev krb5Full}'"
  '';

  nativeBuildInputs = [
    cython
    krb5Full
  ];

  propagatedBuildInputs =  [
    decorator
    six
  ] ++ lib.optional isPy27 enum34;

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.GSS
  ];

  checkInputs = [
    k5test
    nose
    parameterized
    shouldbe
    six
  ];

  doCheck = !stdenv.isDarwin; # many failures on darwin

  # skip tests which fail possibly due to be an upstream issue (see
  # https://github.com/pythongssapi/python-gssapi/issues/220)
  checkPhase = ''
    # some tests don't respond to being disabled through nosetests -x
    echo $'\ndel CredsTestCase.test_add_with_impersonate' >> gssapi/tests/test_high_level.py
    echo $'\ndel TestBaseUtilities.test_acquire_creds_impersonate_name' >> gssapi/tests/test_raw.py
    echo $'\ndel TestBaseUtilities.test_add_cred_impersonate_name' >> gssapi/tests/test_raw.py

    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
    ${python.interpreter} setup.py nosetests -e 'ext_test_\d.*'
  '';
  pythonImportsCheck = [ "gssapi" ];

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/gssapi";
    description = "Python GSSAPI Wrapper";
    license = licenses.mit;
  };
}
