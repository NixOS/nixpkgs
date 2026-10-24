{
  lib,
  python,
  fetchPypi,
}:

python.pkgs.buildPythonPackage rec {
  pname = "django-handleref";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "django_handleref";
    inherit version;
    hash = "sha256-iO72vkgqTet0jKCHZcjicX/PsvOaevNhuz5S5ZfvSh0=";
  };

  build-system = [
    python.pkgs.poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  optional-dependencies = with python.pkgs; {
    docs = [
      markdown-include
      mkdocs
      pymdgen
    ];
  };

  pythonImportsCheck = [
    "django_handleref"
  ];

  meta = {
    description = "Django object tracking";
    homepage = "https://pypi.org/project/django-handleref/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "django-handleref";
  };
}
