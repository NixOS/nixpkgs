{ lib, buildPythonPackage, fetchFromGitHub, python,
  django_hijack, django_nose }:
buildPythonPackage rec {
  pname = "django-hijack-admin";
  version = "2.1.10";

  # the pypi packages don't include everything required for the tests
  src = fetchFromGitHub {
    owner = "arteria";
    repo = "django-hijack-admin";
    rev = "v${version}";
    sha256 = "0m98lchp2y43886n67j4s7miyd50pg2r5r966vjnxmd7nx7qkihf";
  };

  checkInputs = [ django_nose ];
  propagatedBuildInputs = [ django_hijack ];

  checkPhase = ''
    runHook preCheck

    # we have to do a little bit of tinkering to convince the tests to run against the installed package, not the
    # source directory
    mkdir testbase
    pushd testbase
    mv ../runtests.py .
    ${python.interpreter} runtests.py hijack_admin
    popd

    runHook postCheck
  '';

  meta = with lib; {
    description = "Admin integration for django-hijack";
    homepage = "https://github.com/arteria/django-hijack-admin";
    license = licenses.mit;
    maintainers = with maintainers; [ lsix ];
    # may be unmaintained, doesn't work with recent django-hijack:
    # https://github.com/django-hijack/django-hijack-admin/issues/46
    broken = true;
  };
}
