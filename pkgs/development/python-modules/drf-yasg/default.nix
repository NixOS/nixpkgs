{ lib
, buildPythonPackage
, fetchPypi
, inflection
, ruamel_yaml
, setuptools-scm
, six
, coreapi
, djangorestframework
, pytestCheckHook
, pytest-django
, datadiff
}:

buildPythonPackage rec {
  pname = "drf-yasg";
  version = "1.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d50f197c7f02545d0b736df88c6d5cf874f8fea2507ad85ad7de6ae5bf2d9e5a";
  };

  postPatch = ''
    # https://github.com/axnsan12/drf-yasg/pull/710
    substituteInPlace requirements/base.txt --replace packaging ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
    inflection
    ruamel_yaml
    coreapi
    djangorestframework
  ];

  checkInputs = [
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
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };
}
