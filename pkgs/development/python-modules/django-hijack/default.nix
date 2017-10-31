{ stdenv, buildPythonPackage, fetchFromGitHub, python,
  django, django_compat, django_nose
}:
buildPythonPackage rec {
  name = "django-hijack-${version}";
  version = "2.1.4";

  # the pypi packages don't include everything required for the tests
  src = fetchFromGitHub {
    owner = "arteria";
    repo = "django-hijack";
    rev = "v${version}";
    sha256 = "1wbm6l8mzpkj4wsj4fyfamzpzi3day2v1cva5j89v4dn4403jq21";
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