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
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "pythongssapi";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0n13vb3v50vr04vrnql2w00gri0gcf08i0pr0q2p4w8scbsw7kjk";
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

  checkPhase = ''
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
    ${python.interpreter} setup.py nosetests
  '';

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/gssapi;
    description = "Python GSSAPI Wrapper";
    license = licenses.mit;
  };
}
