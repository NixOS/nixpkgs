{
  lib,
  buildPythonPackage,
  libgpiod,
  setuptools,
}:
buildPythonPackage {
  pname = "gpiod";
  inherit (libgpiod) version src;
  pyproject = true;

  build-system = [ setuptools ];

  buildInputs = [ libgpiod ];

  preConfigure = ''
    cd bindings/python
  '';

  # Requires libgpiod built with --enable-tests
  doCheck = false;
  pythonImportsCheck = [ "gpiod" ];

  # the tag component of the version doesn't align
  dontCheckPythonMetadata = true;

  meta = {
    description = "Python bindings for libgpiod";
    homepage = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ lopsided98 ];
  };
}
