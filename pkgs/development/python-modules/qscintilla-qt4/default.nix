{ lib
, buildPythonPackage
, isPy3k
, isPyPy
, pkgs
, python
, pyqt4
}:

buildPythonPackage {
  pname = "qscintilla-qt4";
  version = pkgs.qscintilla-qt4.version;
  format = "other";

  disabled = isPyPy;

  src = pkgs.qscintilla-qt4.src;

  nativeBuildInputs = [ pkgs.xorg.lndir ];

  buildInputs = [ pyqt4.qt pyqt4 ];

  preConfigure = ''
    mkdir -p $out
    lndir ${pyqt4} $out
    rm -rf "$out/nix-support"
    cd Python
    ${python.executable} ./configure-old.py \
        --destdir $out/lib/${python.libPrefix}/site-packages/PyQt4 \
        --apidir $out/api/${python.libPrefix} \
        -n ${pkgs.qscintilla-qt4}/include \
        -o ${pkgs.qscintilla-qt4}/lib \
        --sipdir $out/share/sip
  '';

  meta = with lib; {
    description = "A Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ danbst ];
    platforms = platforms.linux;
  };
}
