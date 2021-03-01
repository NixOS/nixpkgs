{ lib
, pythonPackages
, qscintilla
, qtbase
}:
with pythonPackages;
buildPythonPackage {
  pname = "qscintilla";
  version = qscintilla.version;
  src = qscintilla.src;
  format = "other";

  nativeBuildInputs = [ sip qtbase ];
  buildInputs = [ qscintilla ];
  propagatedBuildInputs = [ pyqt5 ];

  postPatch = ''
    substituteInPlace Python/configure.py \
      --replace \
      "target_config.py_module_dir" \
      "'$out/${python.sitePackages}'"
  '';

  preConfigure = ''
    # configure.py will look for this folder
    mkdir -p $out/share/sip/PyQt5

    cd Python
    substituteInPlace configure.py \
      --replace "qmake = {'CONFIG': 'qscintilla2'}" "qmake = {'CONFIG': 'qscintilla2', 'QT': 'widgets printsupport'}"
    ${python.executable} ./configure.py \
      --pyqt=PyQt5 \
      --destdir=$out/${python.sitePackages}/PyQt5 \
      --stubsdir=$out/${python.sitePackages}/PyQt5 \
      --apidir=$out/api/${python.libPrefix} \
      --qsci-incdir=${qscintilla}/include \
      --qsci-featuresdir=${qscintilla}/mkspecs/features \
      --qsci-libdir=${qscintilla}/lib \
      --pyqt-sipdir=${pyqt5}/share/sip/PyQt5 \
      --qsci-sipdir=$out/share/sip/PyQt5 \
      --sip-incdir=${sip}/include
  '';

  meta = with lib; {
    description = "A Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lsix ];
    homepage = "https://www.riverbankcomputing.com/software/qscintilla/";
  };
}
