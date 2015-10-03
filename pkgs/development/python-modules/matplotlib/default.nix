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
  name = "matplotlib-1.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/matplotlib/${name}.tar.gz";
    sha256 = "1dn05cvd0g984lzhh72wa0z93psgwshbbg93fkab6slx5m3l95av";
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
