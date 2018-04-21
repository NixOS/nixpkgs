{ stdenv, buildPythonPackage, fetchFromGitHub, python,
  django, django_compat, django_nose
}:
buildPythonPackage rec {
  pname = "django-hijack";
  version = "2.1.5";
  name = pname + "-" + version;

  # the pypi packages don't include everything required for the tests
  src = fetchFromGitHub {
    owner = "arteria";
    repo = "django-hijack";
    rev = "v${version}";
    sha256 = "1paiyxhc034336xcd9yzf3azpsapsv26j7w2baxiby71z2hhg0sj";
  };

  checkInputs = [ django_nose ];
  propagatedBuildInputs = [ django django_compat ];

  checkPhase = ''
    runHook preCheck

    # we have to do a little bit of tinkering to convince the tests to run against the installed package, not the
    # source directory
    mkdir testbase
    pushd testbase
    cp ../runtests.py .
    ${python.interpreter} runtests.py hijack
    popd

    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Allows superusers to hijack (=login as) and work on behalf of another user";
    homepage = https://github.com/arteria/django-hijack;
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
