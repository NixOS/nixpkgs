{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, six, typing, pygments
, django, shortuuid, python-dateutil, pytest
, pytest-django, pytestcov, mock, vobject
, werkzeug, glibcLocales, factory_boy
, fetchpatch
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1g7lg0iwmzfdb747fkfgcy890axpfyzv3606axhyd6cvkbg2mz4d";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/${pname}/${pname}/commit/e30b30c9a5c688b41e39b0e1e9dba1e5f0589adf.patch";
      sha256 = "1dfpadqcdyq62pwws5dvhy0zb3r3b8flznhqni85l0vbk0cki0dd";
    })
  ];
  postPatch = ''
    substituteInPlace setup.py --replace "'tox'," ""

    # pip should not be used during tests...
    rm tests/management/commands/test_pipchecker.py
  '';

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") typing;

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

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
