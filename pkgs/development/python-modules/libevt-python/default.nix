{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libevt-python";
  name = pname;
  version = "20221022";

  meta = with lib; {
    description = "Python bindings module for libevt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libevt/";
    downloadPage = "https://github.com/libyal/libevt/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mzPp2iFc8e60V4oEacai9V0H/xnNzoqMgGTtA9Rkvyc=";
  };
}
