{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rangeparser";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    pname = "RangeParser";
    inherit version;
    hash = "sha256-gjA7Iytg802Lv7/rLfhGE0yjz4e6FfOXbEoWNPjhCOY=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rangeparser" ];

  meta = {
    description = "Parses ranges";
    homepage = "https://pypi.org/project/RangeParser/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
