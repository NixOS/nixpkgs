{ lib, buildPythonPackage, fetchPypi, fetchpatch, pkg-config, fuse3, trio, pytestCheckHook, pytest-trio, which }:

buildPythonPackage rec {
  pname = "pyfuse3";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9feb42a8639dc4815522ee6af6f7221552cfd2df1c7a7e9df96767be65e18667";
  };

  patches = [
    # Fixes tests with pytest 6, to be removed in next stable version
    (fetchpatch {
      url = "https://github.com/libfuse/pyfuse3/commit/0070eddfc33fc2fba8eb4fe9353a2d2fa1ae575b.patch";
      sha256 = "0lb4x1j31ihs3qkn61x41k2vqwcjl2fp1c2qx2jg9br6yqhjmg3b";
    })
  ];

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
    license = licenses.gpl2;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
