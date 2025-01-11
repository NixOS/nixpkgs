{
  lib,
  buildPythonPackage,
  fetchPypi,
  linuxHeaders,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DHLDcL2inYV+GI2TEBnDJlGpweqXfAjI2TmxztFjf94=";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace-fail /usr/include ${linuxHeaders}/include
  '';

  build-system = [ setuptools ];

  buildInputs = [ linuxHeaders ];

  doCheck = false;

  pythonImportsCheck = [ "evdev" ];

  meta = with lib; {
    description = "Provides bindings to the generic input event interface in Linux";
    homepage = "https://python-evdev.readthedocs.io/";
    changelog = "https://github.com/gvalkov/python-evdev/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
