{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, six, typing
, django, shortuuid, python-dateutil, pytest
, pytest-django, pytestcov, mock, vobject
, werkzeug, glibcLocales
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0ns1m9sdkcbbz84wvzgxa4f8hf4a8z656jzwx4bw8np9kh96zfjy";
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
