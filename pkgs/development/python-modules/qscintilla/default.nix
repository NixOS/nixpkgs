{ stdenv
, buildPythonPackage
, disabledIf
, isPy3k
, isPyPy
, pkgs
, python
, pyqt4
}:

disabledIf (isPy3k || isPyPy)
  (buildPythonPackage {
    # TODO: Qt5 support
    pname = "qscintilla";
    version = pkgs.qscintilla.version;
    format = "other";

    src = pkgs.qscintilla.src;

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
          -n ${pkgs.qscintilla}/include \
          -o ${pkgs.qscintilla}/lib \
          --sipdir $out/share/sip
    '';

    meta = with stdenv.lib; {
      description = "A Python binding to QScintilla, Qt based text editing control";
      license = licenses.lgpl21Plus;
      maintainers = with maintainers; [ danbst ];
      platforms = platforms.unix;
    };
  })
