{ lib
, stdenv
, fetchPypi
, writeText
, buildPythonPackage
, isPyPy
, pythonOlder

# https://github.com/matplotlib/matplotlib/blob/main/doc/devel/dependencies.rst
# build-system
, certifi
, oldest-supported-numpy
, pkg-config
, pybind11
, setuptools
, setuptools-scm
, wheel

# native libraries
, ffmpeg-headless
, freetype
, qhull

# propagates
, contourpy
, cycler
, fonttools
, kiwisolver
, numpy
, packaging
, pillow
, pyparsing
, python-dateutil

# optional
, importlib-resources

# GTK3
, enableGtk3 ? false
, cairo
, gobject-introspection
, gtk3
, pycairo
, pygobject3

# Tk
# Darwin has its own "MacOSX" backend, PyPy has tkagg backend and does not support tkinter
, enableTk ? (!stdenv.isDarwin && !isPyPy)
, tcl
, tk
, tkinter

# Ghostscript
, enableGhostscript ? true
, ghostscript

# Qt
, enableQt ? false
, pyqt5

# Webagg
, enableWebagg ? false
, tornado

# nbagg
, enableNbagg ? false
, ipykernel

# darwin
, Cocoa

# required for headless detection
, libX11
, wayland
}:

let
  interactive = enableTk || enableGtk3 || enableQt;
in

buildPythonPackage rec {
  version = "3.8.0";
  pname = "matplotlib";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-34UF4cGdXCwmr/NJeny9PM/C6XBD0eTbPnavo5kWS2k=";
  };

  env.XDG_RUNTIME_DIR = "/tmp";

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
    # bring our own system libraries
    # https://github.com/matplotlib/matplotlib/blob/main/doc/devel/dependencies.rst#c-libraries
    ''
      echo "[libs]
      system_freetype=true
      system_qhull=true" > mplsetup.cfg
    '';

  nativeBuildInputs = [
    certifi
    numpy
    oldest-supported-numpy # TODO remove after updating to 3.8.0
    pkg-config
    pybind11
    setuptools
    setuptools-scm
    wheel
  ] ++ lib.optionals enableGtk3 [
    gobject-introspection
  ];

  buildInputs = [
    ffmpeg-headless
    freetype
    qhull
  ] ++ lib.optionals enableGhostscript [
    ghostscript
  ] ++ lib.optionals enableGtk3 [
    cairo
    gtk3
  ] ++ lib.optionals enableTk [
    libX11
    tcl
    tk
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  # clang-11: error: argument unused during compilation: '-fno-strict-overflow' [-Werror,-Wunused-command-line-argument]
  hardeningDisable = lib.optionals stdenv.isDarwin [
    "strictoverflow"
  ];

  propagatedBuildInputs = [
    # explicit
    contourpy
    cycler
    fonttools
    kiwisolver
    numpy
    packaging
    pillow
    pyparsing
    python-dateutil
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-resources
  ] ++ lib.optionals enableGtk3 [
    pycairo
    pygobject3
  ] ++ lib.optionals enableQt [
    pyqt5
  ] ++ lib.optionals enableWebagg [
    tornado
  ] ++ lib.optionals enableNbagg [
    ipykernel
  ] ++ lib.optionals enableTk [
    tkinter
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

  env.MPLSETUPCFG = writeText "mplsetup.cfg" (lib.generators.toINI {} passthru.config);

  # Matplotlib needs to be built against a specific version of freetype in
  # order for all of the tests to pass.
  doCheck = false;

  meta = with lib; {
    description = "Python plotting library, making publication quality plots";
    homepage = "https://matplotlib.org/";
    changelog = "https://github.com/matplotlib/matplotlib/releases/tag/v${version}";
    license = with licenses; [ psfl bsd0 ];
    maintainers = with maintainers; [ lovek323 veprbl ];
  };
}
