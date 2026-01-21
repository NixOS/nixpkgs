{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  djangorestframework,
  orjson,
}:

buildPythonPackage {
  pname = "drf-orjson-renderer";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brianjbuck";
    repo = "drf_orjson_renderer";
    tag = "v${version}";
    hash = "sha256-PMVb+BtTl25BsftQhYlKdEhGhhH3HTlROVYsm+7PBjY=";
  };

  build-system = [ setuptools ];

  doCheck = false; # Tests are broken upstream (https://github.com/brianjbuck/drf_orjson_renderer/pull/26)
  dependencies = [
    django
    djangorestframework
    orjson
  ];

  pythonImportsCheck = [ "drf_orjson_renderer" ];

  meta = {
    description = "JSON renderer and parser for Django Rest Framework using the orjson library";
    homepage = "https://github.com/brianjbuck/drf_orjson_renderer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
