{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "colorize-pinyin";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "colorize_pinyin";
    inherit version;
    hash = "sha256-0qqa2uUOqaLVkEJxDugwtQIKF8Ba5cRVeGww4oS+j7k=";
  };

  build-system = [ setuptools ];

  meta = {
    description = "Search for chinese pinyin and wrap it with HTML";
    homepage = "https://pypi.org/project/colorize-pinyin/";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ jakobgetz ];
    mainProgram = "colorize_pinyin";
  };
}
