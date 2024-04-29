{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libphdi-python";
  version = "20240307";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qn4iZkVpWcm2leVWpJx0l3BFYBY3U8nsR6EzgBz1Uak=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyphdi" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libphdi/releases/tag/${version}";
    description = "Python bindings module for libphdi";
    downloadPage = "https://github.com/libyal/libphdi/releases";
    homepage = "https://github.com/libyal/libphdi";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
