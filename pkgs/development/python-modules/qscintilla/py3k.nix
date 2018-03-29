{ lib
, buildPythonPackage
, fetchPypi
, python
, libsForQt5
, lndir
, pyqt5
, qt5
}:

let
  qscintillaCpp = libsForQt5.qscintilla;
  base = import ./base.nix { inherit lib qscintillaCpp; };
in buildPythonPackage (base // {
  buildInputs = [ lndir qt5.qtbase qscintillaCpp ];
  propagatedBuildInputs = [ pyqt5 ];

  # a dependency on QT's widget module is missing.
  patches = [ ./qscintilla-pyqt5-widgets.patch ];

  preConfigure = ''
    mkdir -p $out
    lndir ${pyqt5} $out
    rm -rf "$out/nix-support"
    cd Python
    ${python.executable} ./configure.py \
        --pyqt=PyQt5 \
        --destdir=$out/lib/${python.libPrefix}/site-packages/PyQt5 \
        --stubsdir=$out/lib/${python.libPrefix}/site-packages/PyQt5 \
        --apidir=$out/api/${python.libPrefix} \
        --qsci-incdir=${qscintillaCpp}/include \
        --qsci-libdir=${qscintillaCpp}/lib \
        --pyqt-sipdir=${pyqt5}/share/sip/PyQt5 \
        --qsci-sipdir=$out/share/sip/PyQt5
  '';
})
