{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libvshadow-python";
  version = "20240229";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3tp3ceYfa557jzAsUlCgr+GOjRmnq9Va5x7so3UX/aY=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvshadow" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libvshadow/releases/tag/${version}";
    description = "Python bindings module for libvshadow";
    downloadPage = "https://github.com/libyal/libvshadow/releases";
    homepage = "https://github.com/libyal/libvshadow";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
