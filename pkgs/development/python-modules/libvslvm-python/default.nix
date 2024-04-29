{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libvslvm-python";
  version = "20240301";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1+7okPMphNzQl5kCf7wQaNgu4xonFyjLvV6AT7WTfUw=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvslvm" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libvslvm/releases/tag/${version}";
    description = "Python bindings module for libvslvm";
    downloadPage = "https://github.com/libyal/libvslvm/releases";
    homepage = "https://github.com/libyal/libvslvm";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
