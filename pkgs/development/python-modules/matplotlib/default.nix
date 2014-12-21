{ stdenv, fetchurl, python, buildPythonPackage
, which, dateutil, nose, numpy, pyparsing, tornado
, freetype, libpng, pkgconfig, mock, pytz
, enableGhostscript ? false, ghostscript ? null
, enableCairo ? false, pycairo ? null
, enableGtk2 ? false, pygtk ? null
, enableGtk3 ? false, pygobject3 ? null, gtk3 ? null
, enableQt4 ? false, pyqt4 ? null
, enableQt5 ? false, pyqt5 ? null
, enableWxWidgets ? false, wxPython ? null }:

assert enableGhostscript -> ghostscript != null;
assert enableCairo -> pycairo != null;
assert enableGtk2 -> pygtk != null;
assert enableGtk3 -> pygobject3 != null && gtk3 != null;
assert enableQt4 -> pyqt4 != null;
assert enableQt5 -> pyqt5 != null;
assert enableWxWidgets -> wxPython != null;

buildPythonPackage rec {
  name = "matplotlib-1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/matplotlib/${name}.tar.gz";
    sha256 = "0m6v9nwdldlwk22gcd339zg6mny5m301fxgks7z8sb8m9wawg8qp";
  };

  buildInputs = [ python which stdenv ]
    ++ stdenv.lib.optional enableGhostscript ghostscript
    ++ stdenv.lib.optional enableGtk3 gtk3;

  propagatedBuildInputs =
    [ dateutil nose numpy pyparsing tornado freetype
      libpng pkgconfig mock pytz
    ]
    ++ stdenv.lib.optional enableCairo pycairo
    ++ stdenv.lib.optional enableGtk2 pygtk
    ++ stdenv.lib.optional enableGtk3 pygobject3
    ++ stdenv.lib.optional enableQt4 pyqt4
    ++ stdenv.lib.optional enableQt5 pyqt5
    ++ stdenv.lib.optional enableWxWidgets wxPython;

  meta = with stdenv.lib; {
    description = "python plotting library, making publication quality plots";
    homepage    = "http://matplotlib.sourceforge.net/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
