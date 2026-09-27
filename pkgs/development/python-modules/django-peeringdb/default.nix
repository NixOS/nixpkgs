{
  lib,
  python,
  fetchPypi,
}:

python.pkgs.buildPythonPackage rec {
  pname = "django-peeringdb";
  version = "3.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django_peeringdb";
    inherit version;
    hash = "sha256-ukz7uqfmRz7qNsnFKjEG3eiNJHOOZOv/iXWxekLS+g0=";
  };

  build-system = [
    python.pkgs.hatchling
  ];

  dependencies = with python.pkgs; [
    asgiref
    django
    django-countries
    django-handleref
    django-inet
  ];

  pythonImportsCheck = [
    "django_peeringdb"
  ];

  meta = {
    description = "PeeringDB Django models";
    homepage = "https://pypi.org/project/django-peeringdb/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "django-peeringdb";
  };
}
