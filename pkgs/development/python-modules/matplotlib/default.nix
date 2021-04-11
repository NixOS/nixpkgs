{ lib, stdenv, fetchPypi, writeText, python, buildPythonPackage, isPy3k, pycairo, backports_functools_lru_cache
, which, cycler, dateutil, nose, numpy, pyparsing, sphinx, tornado, kiwisolver
, freetype, qhull, libpng, pkg-config, mock, pytz, pygobject3, gobject-introspection
, certifi, pillow
, enableGhostscript ? true, ghostscript, gtk3
, enableGtk3 ? false, cairo
# darwin has its own "MacOSX" backend
, enableTk ? !stdenv.isDarwin, tcl, tk, tkinter, libX11
, enableQt ? false, pyqt5
, Cocoa
, pythonOlder
}:

buildPythonPackage rec {
  version = "3.4.1";
  pname = "matplotlib";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "84d4c4f650f356678a5d658a43ca21a41fca13f9b8b00169c0b76e6a6a948908";
  };

  XDG_RUNTIME_DIR = "/tmp";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ which sphinx ]
    ++ lib.optional enableGhostscript ghostscript
    ++ lib.optional stdenv.isDarwin [ Cocoa ];

  propagatedBuildInputs =
    [ cycler dateutil numpy pyparsing tornado freetype qhull
      kiwisolver certifi libpng mock pytz pillow ]
    ++ lib.optionals enableGtk3 [ cairo pycairo gtk3 gobject-introspection pygobject3 ]
    ++ lib.optionals enableTk [ tcl tk tkinter libX11 ]
    ++ lib.optionals enableQt [ pyqt5 ];

  passthru.config = {
    directories = { basedirlist = "."; };
    libs = {
      system_freetype = true;
      system_qhull = true;
    } // lib.optionalAttrs stdenv.isDarwin {
      # LTO not working in darwin stdenv, see #19312
      enable_lto = false;
    };
  };
  setup_cfg = writeText "setup.cfg" (lib.generators.toINI {} passthru.config);
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
      tcl_tk_cache = ''"${tk}/lib", "${tcl}/lib", "${lib.strings.substring 0 3 tk.version}"'';
    in
    lib.optionalString enableTk
      "sed -i '/self.tcl_tk_cache = None/s|None|${tcl_tk_cache}|' setupext.py";

  # Matplotlib needs to be built against a specific version of freetype in
  # order for all of the tests to pass.
  doCheck = false;

  meta = with lib; {
    description = "Python plotting library, making publication quality plots";
    homepage    = "https://matplotlib.org/";
    maintainers = with maintainers; [ lovek323 veprbl ];
  };

}
