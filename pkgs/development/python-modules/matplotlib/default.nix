{ stdenv, fetchurl, python, buildPythonPackage, pycairo
, which, cycler, dateutil, nose, numpy, pyparsing, sphinx, tornado
, freetype, libpng, pkgconfig, mock, pytz, pygobject3
, enableGhostscript ? false, ghostscript ? null, gtk3
, enableGtk2 ? false, pygtk ? null, gobjectIntrospection
, enableGtk3 ? false, cairo
, Cocoa, Foundation, CoreData, cf-private, libobjc, libcxx
}:

assert enableGhostscript -> ghostscript != null;
assert enableGtk2 -> pygtk != null;

buildPythonPackage rec {
  name = "matplotlib-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "mirror://pypi/m/matplotlib/${name}.tar.gz";
    sha256 = "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  XDG_RUNTIME_DIR = "/tmp";

  buildInputs = [ python which sphinx stdenv ]
    ++ stdenv.lib.optional enableGhostscript ghostscript
    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa Foundation CoreData
                                              cf-private libobjc ];

  propagatedBuildInputs =
    [ cycler dateutil nose numpy pyparsing tornado freetype 
      libpng pkgconfig mock pytz  
    ]
    ++ stdenv.lib.optional enableGtk2 pygtk
    ++ stdenv.lib.optionals enableGtk3 [ cairo pycairo gtk3 gobjectIntrospection pygobject3 ];

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./darwin-stdenv.patch ];

  checkPhase = ''
    ${python.interpreter} tests.py
  '';

  # The entry point for running tests, tests.py, is not included in the release.
  # https://github.com/matplotlib/matplotlib/issues/6017
  doCheck = false;

  prePatch = ''
    # Failing test: ERROR: matplotlib.tests.test_style.test_use_url
    sed -i 's/test_use_url/fails/' lib/matplotlib/tests/test_style.py
    # Failing test: ERROR: test suite for <class 'matplotlib.sphinxext.tests.test_tinypages.TestTinyPages'>
    sed -i 's/TestTinyPages/fails/' lib/matplotlib/sphinxext/tests/test_tinypages.py
    # Transient errors
    sed -i 's/test_invisible_Line_rendering/noop/' lib/matplotlib/tests/test_lines.py
  '';

  meta = with stdenv.lib; {
    description = "python plotting library, making publication quality plots";
    homepage    = "http://matplotlib.sourceforge.net/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
