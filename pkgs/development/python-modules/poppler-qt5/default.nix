{ buildPythonPackage, fetchPypi, stdenv, sip, qtbase, pyqt5, poppler, pkgconfig, fetchpatch
, substituteAll
}:

buildPythonPackage rec {
  pname = "python-poppler-qt5";
  version = "0.24.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l69llw1fzwz8y90q0qp9q5pifbrqjjbwii7di54dwghw5fc6w1r";
  };

  patches = [
    (substituteAll {
      src = ./poppler-include-dir.patch;
      poppler_include_dir = "${poppler.dev}/include/poppler";
    })
    (fetchpatch {
      url = "https://github.com/wbsoft/python-poppler-qt5/commit/faf4d1308f89560b0d849671226e3080dfc72e79.patch";
      sha256 = "18krhh6wzsnpxzlzv02nginb1vralla8ai24zqk10nc4mj6fkj86";
    })
  ];

  setupPyBuildFlags = [
    "--pyqt-sip-dir ${pyqt5}/share/sip/PyQt5"
    "--qt-include-dir ${qtbase.dev}/include"
  ];

  buildInputs = [ qtbase.dev poppler ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ sip pyqt5.dev ];

  # no tests, just bindings for `poppler_qt5`
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/wbsoft/python-poppler-qt5;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
