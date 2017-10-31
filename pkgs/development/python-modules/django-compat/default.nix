{ stdenv, buildPythonPackage, fetchFromGitHub, python,
  django, django_nose, six
}:
buildPythonPackage rec {
  pname = "django-compat";
  name = "${pname}-${version}";
  version = "1.0.14";

  # the pypi packages don't include everything required for the tests
  src = fetchFromGitHub {
    owner = "arteria";
    repo = "django-compat";
    rev = "v${version}";
    sha256 = "11g6ra6djkchqk44v8k7biaxd1v69qyyyask5l92vmrvb0qiwvm8";
  };

  checkPhase = ''
    runHook preCheck

    # we have to do a little bit of tinkering to convince the tests to run against the installed package, not the
    # source directory
    mkdir -p testbase/compat
    pushd testbase
    # note we're not copying the direct contents of compat/ (notably __init__.py) so python won't recognize this as a
    # package, but the tests need to be in a specific path for the test templates to get picked up.
    cp -r ../compat/tests compat/
    cp ../runtests.py .
    ${python.interpreter} runtests.py compat/tests
    popd

    runHook postCheck
  '';

  checkInputs = [ django_nose ];
  propagatedBuildInputs = [ django six ];

  meta = with stdenv.lib; {
    description = "Forward and backwards compatibility layer for Django 1.4, 1.7, 1.8, 1.9, 1.10 and 1.11";
    homepage = https://github.com/arteria/django-compat;
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
