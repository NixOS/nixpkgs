{
  lib,
  buildPythonPackage,
  django-taggit,
  django,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-autocomplete-light";
  version = "3.12.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yourlabs";
    repo = "django-autocomplete-light";
    tag = version;
    hash = "sha256-ctNbbmTUgrkLGCo7tgPIJpLn7RmkZSuj54/5RBe/sdA=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  optional-dependencies = {
    tags = [ django-taggit ];
    # nested = [ django-nested-admin ];
    # genericm2m = [ django-generic-m2m ];
    # gfk = [ django-querysetsequence ];
  };

  # Too many un-packaged dependencies
  doCheck = false;

  pythonImportsCheck = [ "dal" ];

  meta = with lib; {
    description = "Fresh approach to autocomplete implementations, specially for Django";
    homepage = "https://django-autocomplete-light.readthedocs.io";
    changelog = "https://github.com/yourlabs/django-autocomplete-light/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ambroisie ];
  };
}
