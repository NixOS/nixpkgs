{ stdenv, buildPythonPackage, fetchFromGitHub, python,
  django, django_compat, django_nose
}:
buildPythonPackage rec {
  pname = "django-hijack";
  version = "2.1.10";

  # the pypi packages don't include everything required for the tests
  src = fetchFromGitHub {
    owner = "arteria";
    repo = "django-hijack";
    rev = "v${version}";
    sha256 = "01fwkjdzvw0yx2spwi7zc1yy64ndq1y72bfmk7kxnq5x803m2ak6";
  };

  checkInputs = [ django_nose ];
  propagatedBuildInputs = [ django django_compat ];

  checkPhase = ''
    runHook preCheck

    # we have to do a little bit of tinkering to convince the tests to run against the installed package, not the
    # source directory
    mkdir testbase
    pushd testbase
    mv ../runtests.py .
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
