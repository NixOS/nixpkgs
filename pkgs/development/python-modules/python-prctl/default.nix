{ lib
, buildPythonPackage
, fetchPypi
, libcap
}:

buildPythonPackage rec {
  pname = "python-prctl";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4ca9a25a7d4f1ace4fffd1f3a2e64ef5208fe05f929f3edd5e27081ca7e67ce";
  };

  patches = [ ./skip_bad_tests.patch ];
  buildInputs = [ libcap ];

  meta = {
    description = "Python(ic) interface to the linux prctl syscall";
    homepage = "https://github.com/seveas/python-prctl";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ catern ];
  };
}
