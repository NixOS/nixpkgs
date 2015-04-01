{ stdenv, fetchurl, qt }:

stdenv.mkDerivation rec {
  pname = "qscintilla";
  version = "2.8.4";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/QScintilla2/QScintilla-${version}/QScintilla-gpl-${version}.tar.gz";
    sha256 = "03z8mc7wpk0hyza9b45pyf523gdk0qsqaywkprmp6ffc81s2sywv";
  };

  buildInputs = [ qt ];

  preConfigure = ''
    cd Qt4Qt5
    sed -i -e "s,\$\$\\[QT_INSTALL_LIBS\\],$out/lib," \
           -e "s,\$\$\\[QT_INSTALL_HEADERS\\],$out/include/," \
           -e "s,\$\$\\[QT_INSTALL_TRANSLATIONS\\],$out/share/qt/translations," \
           -e "s,\$\$\\[QT_INSTALL_DATA\\],$out/share/qt," \
           qscintilla.pro
    qmake qscintilla.pro
  '';

  # TODO PyQt Support.

  meta = {
    description = "A Qt port of the Scintilla text editing library";
    longDescription = ''
      QScintilla is a port to Qt of Neil Hodgson's Scintilla C++ editor
      control.

      As well as features found in standard text editing components,
      QScintilla includes features especially useful when editing and
      debugging source code. These include support for syntax styling,
      error indicators, code completion and call tips. The selection
      margin can contain markers like those used in debuggers to
      indicate breakpoints and the current line. Styling choices are
      more open than with many editors, allowing the use of
      proportional fonts, bold and italics, multiple foreground and
      background colours and multiple fonts.
    '';
    homepage = http://www.riverbankcomputing.com/software/qscintilla/intro;
    license = stdenv.lib.licenses.gpl2; # and gpl3 and commercial
  };
}
