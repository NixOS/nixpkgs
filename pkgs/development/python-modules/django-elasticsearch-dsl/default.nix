{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  elasticsearch-dsl,
  django,
  pythonOlder,
  elastic-transport,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-elasticsearch-dsl";
  version = "8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django-es";
    repo = "django-elasticsearch-dsl";
    rev = "refs/tags/${version}";
    hash = "sha256-GizdFOM4UjI870XdE33D7uXHXkuv/bLYbyi9yyNjti8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    elasticsearch-dsl
    elastic-transport
  ];

  # Tests require running Elasticsearch daemon
  doCheck = false;

  pythonImportsCheck = [ "django_elasticsearch_dsl" ];

  meta = {
    description = "Wrapper around elasticsearch-dsl-py for Django models";
    homepage = "https://github.com/sabricot/django-elasticsearch-dsl";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.onny ];
  };
}
