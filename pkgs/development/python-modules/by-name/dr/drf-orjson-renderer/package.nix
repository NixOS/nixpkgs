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
  version = "1.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brianjbuck";
    repo = "drf_orjson_renderer";
    rev = "8885ef748f0152927106ee068375429774a519df";
    hash = "sha256-opC7KcuTg7kdl8xy8H8ZszJb5nn8vJCpRUUIizdnYqU=";
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
