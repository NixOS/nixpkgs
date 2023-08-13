{ lib
, buildPythonPackage
, libgpiod
}:
buildPythonPackage {
  inherit (libgpiod) pname version src;
  format = "setuptools";

  buildInputs = [ libgpiod ];

  preConfigure = ''
    cd bindings/python
  '';

  # Requires libgpiod built with --enable-tests
  doCheck = false;
  pythonImportsCheck = [ "gpiod" ];

  meta = with lib; {
    description = "Python bindings for libgpiod";
    homepage = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
