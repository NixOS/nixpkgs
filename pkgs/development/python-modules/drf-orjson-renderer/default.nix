{
  lib,
  buildPythonPackage,
  fetchzip,
  setuptools,
  django,
  djangorestframework,
  orjson,
}:

buildPythonPackage {
  pname = "drf-orjson-renderer";
  version = "1.7.3";
  pyproject = true;

  src = fetchzip {
    url = "https://files.pythonhosted.org/packages/4d/3e/5cc16467d91087bf883cdbeb52a06f3a6fa59563ad09b9b84bac72d68716/drf_orjson_renderer-1.7.3.tar.gz";
    hash = "sha256-KOR5GW30Oj8f6houoLHnTi4ZJt9n6o1a66CcApfCTJ4=";
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
