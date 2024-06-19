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
  format = "pyproject";

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

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = "https://github.com/Pylons/colander";
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ domenkozar ];
  };
}
