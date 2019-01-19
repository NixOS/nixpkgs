{ stdenv, buildPythonPackage, fetchFromGitHub, python,
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
    ${python.interpreter} runtests.py hijack_admin
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Admin integration for django-hijack";
    homepage = https://github.com/arteria/django-hijack;
    license = licenses.mit;
    maintainers = with maintainers; [ lsix ];
  };
}
