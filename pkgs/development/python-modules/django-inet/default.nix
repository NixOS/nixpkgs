{
  lib,
  python,
  fetchPypi,
}:

python.pkgs.buildPythonPackage rec {
  pname = "django-inet";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PflusfnOk2EiOREjQ01pUg13NmG/yteDWiuidv1L7D8=";
  };

  build-system = [
    python.pkgs.poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  pythonImportsCheck = [
    "django_inet"
  ];

  meta = {
    description = "Django internet utilities";
    homepage = "https://pypi.org/project/django-inet/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "django-inet";
  };
}
