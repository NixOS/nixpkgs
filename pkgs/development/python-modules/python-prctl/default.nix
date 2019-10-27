{ lib
, buildPythonPackage
, fetchPypi
, libcap
}:

buildPythonPackage rec {
  pname = "python-prctl";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1njgixnavmwq45r3gpkhn1y760sax204clagg4gzwvvdc5bdbssp";
  };

  patches = [ ./skip_bad_tests.patch ];
  buildInputs = [ libcap ];

  meta = {
    description = "Python(ic) interface to the linux prctl syscall";
    homepage = https://github.com/seveas/python-prctl;
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ catern ];
  };
}
