{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libolecf-python";
  version = "20240427";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Awz/Gbc7MPDwEPPR5C06/kzAE69uYLswQMdo8AQW+/0=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyolecf" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libolecf/releases/tag/${version}";
    description = "Python bindings module for libolecf";
    downloadPage = "https://github.com/libyal/libolecf/releases";
    homepage = "https://github.com/libyal/libolecf";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
