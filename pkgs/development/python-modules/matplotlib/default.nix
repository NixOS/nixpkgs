{ stdenv, fetchurl, python, buildPythonPackage, pycairo
, which, dateutil, nose, numpy, pyparsing, tornado
, freetype, libpng, pkgconfig, mock, pytz, pygobject3
, enableGhostscript ? false, ghostscript ? null, gtk3
, enableGtk2 ? false, pygtk ? null, gobjectIntrospection
, enableGtk3 ? false, cairo
}:

assert enableGhostscript -> ghostscript != null;
assert enableGtk2 -> pygtk != null;

buildPythonPackage rec {
  name = "matplotlib-1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/matplotlib/${name}.tar.gz";
    sha256 = "0m6v9nwdldlwk22gcd339zg6mny5m301fxgks7z8sb8m9wawg8qp";
  };
  
  XDG_RUNTIME_DIR = "/tmp";

  buildInputs = [ python which stdenv ]
    ++ stdenv.lib.optional enableGhostscript ghostscript;

  propagatedBuildInputs =
    [ dateutil nose numpy pyparsing tornado freetype 
      libpng pkgconfig mock pytz  
    ]
    ++ stdenv.lib.optional enableGtk2 pygtk
    ++ stdenv.lib.optionals enableGtk3 [ cairo pycairo gtk3 gobjectIntrospection pygobject3 ];

  meta = with stdenv.lib; {
    description = "python plotting library, making publication quality plots";
    homepage    = "http://matplotlib.sourceforge.net/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
