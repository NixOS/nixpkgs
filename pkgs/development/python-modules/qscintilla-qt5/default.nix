{ lib
, pythonPackages
, qscintilla
, lndir
, qtbase
}:
with pythonPackages;
buildPythonPackage rec {
  pname = "qscintilla";
  version = qscintilla.version;
  src = qscintilla.src;
  format = "other";

  nativeBuildInputs = [ lndir sip qtbase ];
  buildInputs = [ qscintilla ];
  propagatedBuildInputs = [ pyqt5 ];

  preConfigure = ''
    mkdir -p $out
    lndir ${pyqt5} $out
    rm -rf "$out/nix-support"
    cd Python
    ${python.executable} ./configure.py \
      --pyqt=PyQt5 \
      --destdir=$out/${python.sitePackages}/PyQt5 \
      --stubsdir=$out/${python.sitePackages}/PyQt5 \
      --apidir=$out/api/${python.libPrefix} \
      --qsci-incdir=${qscintilla}/include \
      --qsci-libdir=${qscintilla}/lib \
      --pyqt-sipdir=${pyqt5}/share/sip/PyQt5 \
      --qsci-sipdir=$out/share/sip/PyQt5 \
      --sip-incdir=${sip}/include
  '';

  meta = with lib; {
    description = "A Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lsix ];
    homepage = https://www.riverbankcomputing.com/software/qscintilla/;
  };
}
