{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, markdown
, pillow
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "django-markdownx";
  version = "4.0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neutronX";
    repo = "django-markdownx";
    rev = "refs/tags/v${version}";
    hash = "sha256-FZPUlogVd3FMGeH1vfKHA3tXVps0ET+UCQJflpiV2lE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    django
    markdown
    pillow
  ];

  # tests only executeable in vagrant
  doCheck = false;

  pythonImportsCheck = [
    "markdownx"
  ];

  meta = with lib; {
    description = "Comprehensive Markdown plugin built for Django";
    homepage = "https://github.com/neutronX/django-markdownx/";
    changelog = "https://github.com/neutronX/django-markdownx/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ derdennisop ];
  };
}
