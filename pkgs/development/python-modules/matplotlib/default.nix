{ lib, stdenv, fetchPypi, writeText, buildPythonPackage, isPy3k, pycairo
, which, cycler, python-dateutil, numpy, pyparsing, sphinx, tornado, kiwisolver
, freetype, qhull, libpng, pkg-config, mock, pytz, pygobject3, gobject-introspection
, certifi, pillow, fonttools, setuptools-scm, setuptools-scm-git-archive, packaging
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
  version = "3.5.2";
  pname = "matplotlib";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "18h78s5ld1i6mz00w258hy29909nfr3ddq6ry9kq18agw468bks8";
  };

  XDG_RUNTIME_DIR = "/tmp";

  nativeBuildInputs = [
    pkg-config
    setuptools-scm
    setuptools-scm-git-archive
  ];

  buildInputs = [
    which
    sphinx
  ] ++ lib.optional enableGhostscript [
    ghostscript
  ] ++ lib.optional stdenv.isDarwin [
    Cocoa
  ];

  propagatedBuildInputs = [
    certifi
    cycler
    fonttools
    freetype
    kiwisolver
    libpng
    mock
    numpy
    packaging
    pillow
    pyparsing
    python-dateutil
    pytz
    qhull
    tornado
  ] ++ lib.optionals enableGtk3 [
    cairo
    gobject-introspection
    gtk3
    pycairo
    pygobject3
  ] ++ lib.optionals enableTk [
    libX11
    tcl
    tk
    tkinter
  ] ++ lib.optionals enableQt [
    pyqt5
  ];

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

  MPLSETUPCFG = writeText "mplsetup.cfg" (lib.generators.toINI {} passthru.config);

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
    '' +
    # avoid matplotlib trying to download dependencies
    ''
      echo "[libs]
      system_freetype=true
      system_qhull=true" > mplsetup.cfg
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
