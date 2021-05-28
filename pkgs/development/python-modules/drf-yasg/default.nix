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
  version = "1.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5572e9d5baab9f6b49318169df9789f7399d0e3c7bdac8fdb8dfccf1d5d2b1ca";
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
