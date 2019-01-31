{ lib
, buildPythonPackage
, qscintillaCpp
, lndir
, sip
, python
, pyqt5 }:

buildPythonPackage rec {
  pname = "qscintilla";
  version = qscintillaCpp.version;
  src = qscintillaCpp.src;
  format = "other";

  nativeBuildInputs = [ lndir sip ];
  buildInputs = [ qscintillaCpp ];
  propagatedBuildInputs = [ pyqt5 ];

  preConfigure = ''
    mkdir -p $out
    lndir ${pyqt5} $out
    rm -rf "$out/nix-support"
    cd Python
    ${python.executable} ./configure.py \
      --pyqt=PyQt5 \
      --destdir=$out/lib/${python.sitePackages}/PyQt5 \
      --stubsdir=$out/lib/${python.sitePackages}/PyQt5 \
      --apidir=$out/api/${python.libPrefix} \
      --qsci-incdir=${qscintillaCpp}/include \
      --qsci-libdir=${qscintillaCpp}/lib \
      --pyqt-sipdir=${pyqt5}/share/sip/PyQt5 \
      --qsci-sipdir=$out/share/sip/PyQt5
  '';

  meta = with lib; {
    description = "A Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lsix ];
    homepage = https://www.riverbankcomputing.com/software/qscintilla/;
  };
}
