{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  babel,
  translationstring,
  iso8601,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colander";
  version = "2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QZzWgXjS7m7kyuXVyxgwclY0sKKECRcVbonrJZIjfvM=";
  };

  nativeBuildInputs = [
    babel
    setuptools
  ];

  propagatedBuildInputs = [
    translationstring
    iso8601
  ];

  pythonImportsCheck = [ "colander" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Simple schema-based serialization and deserialization library";
    homepage = "https://github.com/Pylons/colander";
    license = lib.licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = [ ];
  };
}
