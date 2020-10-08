{ stdenv, fetchPypi, python, buildPythonPackage, isPy3k, pycairo, backports_functools_lru_cache
, which, cycler, dateutil, nose, numpy, pyparsing, sphinx, tornado, kiwisolver
, freetype, libpng, pkgconfig, mock, pytz, pygobject3, gobject-introspection
, certifi, pillow
, enableGhostscript ? true, ghostscript ? null, gtk3
, enableGtk3 ? false, cairo
# darwin has its own "MacOSX" backend
, enableTk ? !stdenv.isDarwin, tcl ? null, tk ? null, tkinter ? null, libX11 ? null
, enableQt ? false, pyqt5 ? null
, Cocoa
, pythonOlder
}:

assert enableGhostscript -> ghostscript != null;
assert enableTk -> (tcl != null)
                && (tk != null)
                && (tkinter != null)
                && (libX11 != null)
                ;
assert enableQt -> pyqt5 != null;

buildPythonPackage rec {
  version = "3.3.1";
  pname = "matplotlib";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "87f53bcce90772f942c2db56736788b39332d552461a5cb13f05ff45c1680f0e";
  };

  XDG_RUNTIME_DIR = "/tmp";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ which sphinx ]
    ++ stdenv.lib.optional enableGhostscript ghostscript
    ++ stdenv.lib.optional stdenv.isDarwin [ Cocoa ];

  propagatedBuildInputs =
    [ cycler dateutil numpy pyparsing tornado freetype kiwisolver
      certifi libpng mock pytz pillow ]
    ++ stdenv.lib.optionals enableGtk3 [ cairo pycairo gtk3 gobject-introspection pygobject3 ]
    ++ stdenv.lib.optionals enableTk [ tcl tk tkinter libX11 ]
    ++ stdenv.lib.optionals enableQt [ pyqt5 ];

  setup_cfg = if stdenv.isDarwin then ./setup-darwin.cfg else ./setup.cfg;
  preBuild = ''
    cp "$setup_cfg" ./setup.cfg
  '';

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

  # Matplotlib needs to be built against a specific version of freetype in
  # order for all of the tests to pass.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python plotting library, making publication quality plots";
    homepage    = "https://matplotlib.org/";
    maintainers = with maintainers; [ lovek323 veprbl ];
  };

}
