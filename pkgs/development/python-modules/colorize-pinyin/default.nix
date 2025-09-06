{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "colorize_pinyin";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0qqa2uUOqaLVkEJxDugwtQIKF8Ba5cRVeGww4oS+j7k=";
  };

  build-system = [setuptools];

  dependencies = [];

  meta = {
    description = "search for chinese pinyin and wrap it with HTML.";
    homepage = "https://pypi.org/project/colorize-pinyin/";
    changelog = "https://pypi.org/project/colorize-pinyin/${version}";
    license = lib.licenses.wtfpl;
    maintainers = [];
  };
}
