{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-jsonform";
  version = "2.23.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bhch";
    repo = "django-jsonform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OyVaaMldvAPqyML7eWMk8FtML5ssPtaDWGlqqx9fSkM=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  pythonImportsCheck = [ "django_jsonform" ];

  meta = {
    description = "Better, user-friendly JSON editing form field for Django admin";
    homepage = "https://github.com/bhch/django-jsonform";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kiara ];
  };
})
