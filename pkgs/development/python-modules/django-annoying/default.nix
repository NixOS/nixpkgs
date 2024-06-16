{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  django,
  six,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-annoying";
  version = "0.10.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "skorokithakis";
    repo = "django-annoying";
    rev = "v${version}";
    hash = "sha256-M1zOLr1Vjf2U0xlW66Mpno+S+b4IKLklN+kYxRaj6cA=";
  };

  patches = [
    (fetchpatch {
      name = "django-4-compatibility.patch";
      url = "https://github.com/skorokithakis/django-annoying/pull/101/commits/51b5bd7bc8bb7a410400667e00d0813603df32bd.patch";
      hash = "sha256-gLRlAtIHHJ85I88af3C3y+ZT+nXrj2KrV7QgOuEqspk=";
    })
  ];

  propagatedBuildInputs = [
    django
    six
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A django application that tries to eliminate annoying things in the Django framework";
    homepage = "https://skorokithakis.github.io/django-annoying/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ambroisie ];
  };
}
