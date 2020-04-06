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
  version = "1.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ri5h5xsacm99c6gvb4ldwisbqgiv2vq8qbn7vrh6vplzlpyvzb8";
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
    homepage = https://github.com/axnsan12/drf-yasg;
    maintainers = with maintainers; [ ivegotasthma ];
    license = licenses.bsd3;
  };
}
