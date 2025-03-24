{
  lib,
  buildPythonPackage,
  fetchPypi,
  linuxHeaders,
  setuptools,
}:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3GQKBkyxyf4fi5cNwgOZRaKidde37mIoS/QnI4q+Re4=";
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
