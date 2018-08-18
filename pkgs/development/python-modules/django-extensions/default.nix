{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, six, typing
, django, shortuuid, python-dateutil, pytest
, pytest-django, pytestcov, mock, vobject
, werkzeug, glibcLocales
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1xf84wq7ab1zfb3nmf4qgw6mjf5xafjwr3175dyrqrrn6cpvcr4a";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'tox'," ""
  '';

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") typing;

  checkInputs = [
    django shortuuid python-dateutil pytest
    pytest-django pytestcov mock vobject
    werkzeug glibcLocales
  ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A collection of custom extensions for the Django Framework";
    homepage = https://github.com/django-extensions/django-extensions;
    license = licenses.mit;
  };
}
