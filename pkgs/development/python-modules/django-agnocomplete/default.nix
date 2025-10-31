{
  lib,
  django,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  requests,
  six,
}:
buildPythonPackage rec {
  pname = "django-agnocomplete";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peopledoc";
    repo = "django-agnocomplete";
    rev = version;
    hash = "sha256-SDuLJM/ZvROkBOSbaVi6FMDRcR5Um4UrdPSq1ZMrlXM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  doCheck = false;

  dependencies = [
    django
    requests
    six
  ];

  pythonImportsCheck = [
    "agnocomplete"
  ];

  meta = {
    description = "A front-end agnostic toolbox for autocompletion fields";
    homepage = "https://github.com/peopledoc/django-agnocomplete";
    changelog = "https://github.com/peopledoc/django-agnocomplete/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      LorenzBischof
      jcollie
    ];
    mainProgram = "django-agnocomplete";
  };
}
