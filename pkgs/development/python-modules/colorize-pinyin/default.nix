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

  build-system = [ setuptools ];

  meta = {
    description = "search for chinese pinyin and wrap it with HTML.";
    homepage = "https://pypi.org/project/colorize-pinyin/";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ jakobgetz ];
    mainProgram = "colorize_pinyin";
  };
}
