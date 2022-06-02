{ stdenv, lib, buildPythonPackage, fetchPypi, pkg-config, fuse3, trio, pytestCheckHook, pytest-trio, which, pythonAtLeast }:

buildPythonPackage rec {
  pname = "pyfuse3";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22d146dac59a8429115e9a93317975ea54b35e0278044a94d3fac5b4ad5f7e33";
  };

  disabled = pythonAtLeast "3.10";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse3 ];

  propagatedBuildInputs = [ trio ];

  checkInputs = [
    pytestCheckHook
    pytest-trio
    which
    fuse3
  ];

  # Checks if a /usr/bin directory exists, can't work on NixOS
  disabledTests = [ "test_listdir" ];

  meta = with lib; {
    description = "Python 3 bindings for libfuse 3 with async I/O support";
    homepage = "https://github.com/libfuse/pyfuse3";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
