{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, six
, decorator
, nose
, krb5Full
, darwin
, parameterized
, shouldbe
, cython
, python
, k5test
}:

buildPythonPackage rec {
  pname = "gssapi";
  version = "1.6.9";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pythongssapi";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "1shm3pc0l2r91qadkpq4bx45my0165nw3kdcp0gw4lk50z215hag";
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
  ];

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

  doCheck = pythonOlder "3.8"  # `shouldbe` not available
    && !stdenv.isDarwin;  # many failures on darwin

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
