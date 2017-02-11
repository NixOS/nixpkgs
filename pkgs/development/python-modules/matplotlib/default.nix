{ stdenv, fetchurl, python, buildPythonPackage, pycairo
, which, cycler, dateutil, nose, numpy, pyparsing, sphinx, tornado
, freetype, libpng, pkgconfig, mock, pytz, pygobject3, functools32, subprocess32
, enableGhostscript ? false, ghostscript ? null, gtk3
, enableGtk2 ? false, pygtk ? null, gobjectIntrospection
, enableGtk3 ? false, cairo
, enableTk ? false, tcl ? null, tk ? null, tkinter ? null, libX11 ? null
, enableQt ? false, pyqt4
, libcxx
}:

assert enableGhostscript -> ghostscript != null;
assert enableGtk2 -> pygtk != null;
assert enableTk -> (tcl != null)
                && (tk != null)
                && (tkinter != null)
                && (libX11 != null)
                ;
assert enableQt -> pyqt4 != null;

buildPythonPackage rec {
  name = "matplotlib-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://pypi/m/matplotlib/${name}.tar.gz";
    sha256 = "04zqymd5dw6lxvfbxf1sycdnibjk5qky5rfsn6wb46lwha2hkkrn";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  XDG_RUNTIME_DIR = "/tmp";

  buildInputs = [ python which sphinx stdenv ]
    ++ stdenv.lib.optional enableGhostscript ghostscript;

  propagatedBuildInputs =
    [ cycler dateutil nose numpy pyparsing tornado freetype
      libpng pkgconfig mock pytz
    ]
    ++ stdenv.lib.optional enableGtk2 pygtk
    ++ stdenv.lib.optionals enableGtk3 [ cairo pycairo gtk3 gobjectIntrospection pygobject3 ]
    ++ stdenv.lib.optionals enableTk [ tcl tk tkinter libX11 ]
    ++ stdenv.lib.optionals enableQt [ pyqt4 ]
    ++ stdenv.lib.optionals (builtins.hasAttr "isPy2" python) [ functools32 subprocess32 ];

  patches =
    [ ./basedirlist.patch ] ++
    stdenv.lib.optionals stdenv.isDarwin [ ./darwin-stdenv.patch ];

  # Matplotlib tries to find Tcl/Tk by opening a Tk window and asking the
  # corresponding interpreter object for its library paths. This fails if
  # `$DISPLAY` is not set. The fallback option assumes that Tcl/Tk are both
  # installed under the same path which is not true in Nix.
  # With the following patch we just hard-code these paths into the install
  # script.
  postPatch =
    let
      inherit (stdenv.lib.strings) substring;
      tcl_tk_cache = ''"${tk}/lib", "${tcl}/lib", "${substring 0 3 tk.version}"'';
    in
    stdenv.lib.optionalString enableTk
      "sed -i '/self.tcl_tk_cache = None/s|None|${tcl_tk_cache}|' setupext.py";

  checkPhase = ''
    ${python.interpreter} tests.py
  '';

  # Test data is not included in the distribution (the `tests` folder
  # is missing)
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
    description = "Python plotting library, making publication quality plots";
    homepage    = "http://matplotlib.sourceforge.net/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
