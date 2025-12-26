{
  lib,
  buildPythonPackage,
  fetchPypi,
  linuxHeaders,
  setuptools,
}:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XTJ4iSzh+Sp01r+IjMhSXZ9or4Xb4zbJXRyH+49CMGk=";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace-fail /usr/include ${linuxHeaders}/include
  '';

  build-system = [ setuptools ];

  buildInputs = [ linuxHeaders ];

  doCheck = false;

  pythonImportsCheck = [ "evdev" ];

  meta = {
    description = "Provides bindings to the generic input event interface in Linux";
    homepage = "https://python-evdev.readthedocs.io/";
    changelog = "https://github.com/gvalkov/python-evdev/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
