{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  django,
  djangorestframework,
  inflection,
  packaging,
  pytz,
  pyyaml,
  uritemplate,
  datadiff,
  dj-database-url,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "drf-yasg";
  version = "1.21.14";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "drf_yasg";
    hash = "sha256-aNYtX3UFYRupV3EVyDs2IRzCDZdIpQzpWkSr5BFyfRA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-scm ~= 7.0" "setuptools-scm >= 7.0"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    django
    djangorestframework
    inflection
    packaging
    pytz
    pyyaml
    uritemplate
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    datadiff
    dj-database-url
  ];

  env.DJANGO_SETTINGS_MODULE = "testproj.settings.local";

  preCheck = ''
    cd testproj
  '';

  # a lot of libraries are missing
  doCheck = false;

  pythonImportsCheck = [ "drf_yasg" ];

  meta = {
    description = "Generation of Swagger/OpenAPI schemas for Django REST Framework";
    homepage = "https://github.com/axnsan12/drf-yasg";
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
