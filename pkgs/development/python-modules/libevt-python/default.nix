{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libevt-python";

  version = "20221022";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mzPp2iFc8e60V4oEacai9V0H/xnNzoqMgGTtA9Rkvyc=";
  };

  meta = with lib; {
    description = "Python bindings module for libevt";
    downloadPage = "https://github.com/libyal/libevt/releases";
    homepage = "https://github.com/libyal/libevt/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };

}
