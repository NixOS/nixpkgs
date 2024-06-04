{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  types-psycopg2,
}:

buildPythonPackage rec {
  pname = "django-types";
  version = "0.19.1";
  pyproject = true;

  src = fetchPypi {
    pname = "django_types";
    inherit version;
    hash = "sha256-WueYhhLPb7w1ewGLvDs6h4tl4EJ1zEbg011mpwja/xI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ types-psycopg2 ];

  meta = with lib; {
    description = "Type stubs for Django";
    homepage = "https://github.com/sbdchd/django-types";
    license = licenses.mit;
    maintainers = with maintainers; [ thubrecht ];
  };
}
