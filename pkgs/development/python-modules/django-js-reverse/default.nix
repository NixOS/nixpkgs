{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, python
, django
, nodejs
, js2py
, six
}:

buildPythonPackage rec {
  pname = "django-js-reverse";
  # Support for Django 4.0 not yet released
  version = "unstable-2022-09-16";

  src = fetchFromGitHub {
    owner = "ierror";
    repo = "django-js-reverse";
    rev = "7cab78c4531780ab4b32033d5104ccd5be1a246a";
    sha256 = "sha256-oA4R5MciDMcSsb+GAgWB5jhj+nl7E8t69u0qlx2G93E=";
  };

  patches = [
    (fetchpatch {
      name = "fix-requires_system_checks-list-or-tuple";
      url = "https://github.com/ierror/django-js-reverse/commit/1477ba44b62c419d12ebec86e56973f1ae56f712.patch";
      sha256 = "sha256-xUtCziewVhnCOaNWddJBH4/Vvhwjjq/wcQDvh2YzWMQ=";
    })
  ];

  propagatedBuildInputs = [
    django
  ];

  nativeCheckInputs = [
    nodejs
    js2py
    six
  ];

  checkPhase = ''
    ${python.interpreter} django_js_reverse/tests/unit_tests.py
  '';

  pythonImportsCheck = [ "django_js_reverse" ];

  meta = with lib; {
    description = "Javascript url handling for Django that doesn't hurt";
    homepage = "https://django-js-reverse.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
