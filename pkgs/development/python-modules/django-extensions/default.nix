{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, six, typing, pygments
, django, shortuuid, python-dateutil, pytest
, pytest-django, pytestcov, mock, vobject
, werkzeug, glibcLocales, factory_boy
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "08vggm6wrn5cbf8brfprif0rjrkqz06wddsw0ir1skkk8q2sp1b2";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'tox'," ""

    # not yet pytest 5 compatible?
    rm tests/management/commands/test_set_fake_emails.py
    rm tests/management/commands/test_set_fake_passwords.py
    rm tests/management/commands/test_validate_templates.py

    # pip should not be used during tests...
    rm tests/management/commands/test_pipchecker.py
  '';

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") typing;

  checkInputs = [
    django shortuuid python-dateutil pytest
    pytest-django pytestcov mock vobject
    werkzeug glibcLocales factory_boy pygments
  ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A collection of custom extensions for the Django Framework";
    homepage = https://github.com/django-extensions/django-extensions;
    license = licenses.mit;
  };
}
