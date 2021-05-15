{ lib, buildPythonPackage, fetchPypi, pkg-config, fuse3, trio, pytestCheckHook, pytest-trio, which }:

buildPythonPackage rec {
  pname = "pyfuse3";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45f0053ad601b03a36e2c283a5271403674245a66a0daf50e3deaab0ea4fa82f";
  };

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
