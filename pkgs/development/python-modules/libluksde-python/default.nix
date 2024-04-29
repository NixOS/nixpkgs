{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libluksde-python";
  version = "20240114";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3memvir7wBXruXgmVG83aw6NI/T/jIw2mWnJFuoPuBc=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyluksde" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libluksde/releases/tag/${version}";
    description = "Python bindings module for libluksde";
    downloadPage = "https://github.com/libyal/libluksde/releases";
    homepage = "https://github.com/libyal/libluksde";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
