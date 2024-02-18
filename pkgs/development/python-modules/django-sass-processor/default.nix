{ lib
, buildPythonPackage
, django
, django-compressor
, fetchFromGitHub
, jinja2
, libsass
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-sass-processor";
  version = "1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jrief";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kDhCJ/V2xwLqw3k0W1NLxUrxbvjuKGclWyAuFpGVyQU=";
  };

  propagatedBuildInputs = [
    django
    django-compressor
    libsass
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    jinja2
    django-compressor
  ];

  meta = with lib; {
    description = "SASS processor to compile SCSS files into *.css, while rendering, or offline. ";
    homepage = "https://github.com/jrief/django-sass-processor/tree/master";
    license = licenses.mit;
    maintainers = with maintainers; [ rogryza ];
  };
}


