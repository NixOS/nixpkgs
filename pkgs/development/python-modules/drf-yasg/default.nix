{
  stdenv,
  buildPythonPackage,
  fetchPypi,
  inflection,
  ruamel_yaml,
  setuptools_scm,
  six,
  coreapi,
  djangorestframework,
}:

buildPythonPackage rec {
  pname = "drf-yasg";
  version = "1.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d50f197c7f02545d0b736df88c6d5cf874f8fea2507ad85ad7de6ae5bf2d9e5a";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    six
    inflection
    ruamel_yaml
    coreapi
    djangorestframework
  ];

  meta = with stdenv.lib; {
    description = "Generation of Swagger/OpenAPI schemas for Django REST Framework";
    homepage = "https://github.com/axnsan12/drf-yasg";
    maintainers = with maintainers; [ ivegotasthma ];
    license = licenses.bsd3;
  };
}
