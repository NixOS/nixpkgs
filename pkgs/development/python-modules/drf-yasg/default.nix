{
  lib,
  buildPythonPackage,
  fetchPypi,
  inflection,
  ruamel-yaml,
  setuptools-scm,
  six,
  coreapi,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
  datadiff,
}:

buildPythonPackage rec {
  pname = "drf-yasg";
  version = "1.21.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TDuTBos9/KaWmrERFV5N1vey1oC5h3jej9Rgt4N72w0=";
  };

  postPatch = ''
    # https://github.com/axnsan12/drf-yasg/pull/710
    sed -i "/packaging/d" requirements/base.txt
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    six
    inflection
    ruamel-yaml
    coreapi
    djangorestframework
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    datadiff
  ];

  # ImportError: No module named 'testproj.settings'
  doCheck = false;

  pythonImportsCheck = [ "drf_yasg" ];

  meta = with lib; {
    description = "Generation of Swagger/OpenAPI schemas for Django REST Framework";
    homepage = "https://github.com/axnsan12/drf-yasg";
    maintainers = [ ];
    license = licenses.bsd3;
  };
}
