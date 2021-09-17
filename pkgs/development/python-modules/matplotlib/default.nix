{ lib, stdenv, fetchPypi, writeText, buildPythonPackage, isPy3k, pycairo
, which, cycler, python-dateutil, numpy, pyparsing, sphinx, tornado, kiwisolver
, freetype, qhull, libpng, pkg-config, mock, pytz, pygobject3, gobject-introspection
, certifi, pillow
, enableGhostscript ? true, ghostscript, gtk3
, enableGtk3 ? false, cairo
# darwin has its own "MacOSX" backend
, enableTk ? !stdenv.isDarwin, tcl, tk, tkinter
, enableQt ? false, pyqt5
# required for headless detection
, libX11, wayland
, Cocoa
}:

let
  interactive = enableTk || enableGtk3 || enableQt;
in

buildPythonPackage rec {
  version = "3.4.3";
  pname = "matplotlib";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06032j0ccjxldx4z9kf97qps2g36mfgvy1nap3b9n75kzmnm4kzw";
  };

  XDG_RUNTIME_DIR = "/tmp";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ which sphinx ]
    ++ lib.optional enableGhostscript ghostscript
    ++ lib.optional stdenv.isDarwin [ Cocoa ];

  propagatedBuildInputs =
    [ cycler python-dateutil numpy pyparsing tornado freetype qhull
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
    lib.optionalString enableTk ''
      sed -i '/self.tcl_tk_cache = None/s|None|${tcl_tk_cache}|' setupext.py
    '' + lib.optionalString (stdenv.isLinux && interactive) ''
      # fix paths to libraries in dlopen calls (headless detection)
      substituteInPlace src/_c_internal_utils.c \
        --replace libX11.so.6 ${libX11}/lib/libX11.so.6 \
        --replace libwayland-client.so.0 ${wayland}/lib/libwayland-client.so.0
    '';

  # Matplotlib needs to be built against a specific version of freetype in
  # order for all of the tests to pass.
  doCheck = false;

  meta = with lib; {
    description = "Python plotting library, making publication quality plots";
    homepage    = "https://matplotlib.org/";
    license     = with licenses; [ psfl bsd0 ];
    maintainers = with maintainers; [ lovek323 veprbl ];
  };

}
