{ lib
, pythonPackages
, qscintilla
, qtbase
}:

let
  inherit (pythonPackages) buildPythonPackage isPy3k python sip_4 pyqt5;
in buildPythonPackage rec {
  pname = "qscintilla";
  version = qscintilla.version;
  src = qscintilla.src;
  format = "other";

  disabled = !isPy3k;

  nativeBuildInputs = [ sip_4 qtbase ];
  buildInputs = [ qscintilla ];
  propagatedBuildInputs = [ pyqt5 ];

  dontWrapQtApps = true;

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
      --pyqt-sipdir=${pyqt5}/${python.sitePackages}/PyQt5/bindings \
      --qsci-sipdir=$out/share/sip/PyQt5 \
      --sip-incdir=${sip_4}/include
  '';

  postInstall = ''
    # Needed by pythonImportsCheck to find the module
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
  '';

  # Checked using pythonImportsCheck
  doCheck = false;

  pythonImportsCheck = [ "PyQt5.Qsci" ];

  meta = with lib; {
    description = "A Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lsix ];
    homepage = "https://www.riverbankcomputing.com/software/qscintilla/";
  };
}
