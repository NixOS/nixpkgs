{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libfsntfs-python";
  version = "20240119";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ts400b8VQpDLHlGJvHokUsHiS/OhGTtB27Sn2foqAUY=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsntfs" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libfsntfs/releases/tag/${version}";
    description = "Python bindings module for libfsntfs";
    homepage = "https://github.com/libyal/libfsntfs";
    downloadPage = "https://github.com/libyal/libfsntfs/releases";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
