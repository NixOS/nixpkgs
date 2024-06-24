{
  lib,
  stdenv,
  fetchPypi,
  writeText,
  buildPythonPackage,
  isPyPy,
  pythonOlder,

  # build-system
  certifi,
  pkg-config,
  pybind11,
  setuptools,
  setuptools-scm,

  # native libraries
  ffmpeg-headless,
  freetype,
  qhull,

  # propagates
  contourpy,
  cycler,
  fonttools,
  kiwisolver,
  numpy,
  packaging,
  pillow,
  pyparsing,
  python-dateutil,

  # optional
  importlib-resources,

  # GTK3
  enableGtk3 ? false,
  cairo,
  gobject-introspection,
  gtk3,
  pycairo,
  pygobject3,

  # Tk
  # Darwin has its own "MacOSX" backend, PyPy has tkagg backend and does not support tkinter
  enableTk ? (!stdenv.isDarwin && !isPyPy),
  tcl,
  tk,
  tkinter,

  # Ghostscript
  enableGhostscript ? true,
  ghostscript,

  # Qt
  enableQt ? false,
  pyqt5,

  # Webagg
  enableWebagg ? false,
  tornado,

  # nbagg
  enableNbagg ? false,
  ipykernel,

  # darwin
  Cocoa,

  # required for headless detection
  libX11,
  wayland,

  # Reverse dependency
  sage,
}:

let
  interactive = enableTk || enableGtk3 || enableQt;
in

buildPythonPackage rec {
  version = "3.8.4";
  pname = "matplotlib";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iqw5fV6ewViWDjHDgcX/xS3dUr2aR3F+KmlAOBZ9/+o=";
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
    ''
      substituteInPlace pyproject.toml \
        --replace-fail '"numpy>=2.0.0rc1,<2.3",' ""
    ''
    + lib.optionalString enableTk ''
      sed -i '/self.tcl_tk_cache = None/s|None|${tcl_tk_cache}|' setupext.py
    ''
    + lib.optionalString (stdenv.isLinux && interactive) ''
      # fix paths to libraries in dlopen calls (headless detection)
      substituteInPlace src/_c_internal_utils.c \
        --replace libX11.so.6 ${libX11}/lib/libX11.so.6 \
        --replace libwayland-client.so.0 ${wayland}/lib/libwayland-client.so.0
    '';

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals enableGtk3 [ gobject-introspection ];

  buildInputs =
    [
      ffmpeg-headless
      freetype
      qhull
    ]
    ++ lib.optionals enableGhostscript [ ghostscript ]
    ++ lib.optionals enableGtk3 [
      cairo
      gtk3
    ]
    ++ lib.optionals enableTk [
      libX11
      tcl
      tk
    ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  # clang-11: error: argument unused during compilation: '-fno-strict-overflow' [-Werror,-Wunused-command-line-argument]
  hardeningDisable = lib.optionals stdenv.isDarwin [ "strictoverflow" ];

  build-system = [
    certifi
    numpy
    pybind11
    setuptools
    setuptools-scm
  ];

  dependencies =
    [
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
    ]
    ++ lib.optionals (pythonOlder "3.10") [ importlib-resources ]
    ++ lib.optionals enableGtk3 [
      pycairo
      pygobject3
    ]
    ++ lib.optionals enableQt [ pyqt5 ]
    ++ lib.optionals enableWebagg [ tornado ]
    ++ lib.optionals enableNbagg [ ipykernel ]
    ++ lib.optionals enableTk [ tkinter ];

  passthru.config = {
    directories = {
      basedirlist = ".";
    };
    libs = {
      system_freetype = true;
      system_qhull = true;
      # LTO not working in darwin stdenv, see #19312
      enable_lto = !stdenv.isDarwin;
    };
  };

  passthru.tests = {
    inherit sage;
  };

  env.MPLSETUPCFG = writeText "mplsetup.cfg" (lib.generators.toINI { } passthru.config);

  # Encountering a ModuleNotFoundError, as describved and investigated at:
  # https://github.com/NixOS/nixpkgs/issues/255262 . It could be that some of
  # which may fail due to a freetype version that doesn't match the freetype
  # version used by upstream.
  doCheck = false;

  meta = with lib; {
    description = "Python plotting library, making publication quality plots";
    homepage = "https://matplotlib.org/";
    changelog = "https://github.com/matplotlib/matplotlib/releases/tag/v${version}";
    license = with licenses; [
      psfl
      bsd0
    ];
    maintainers = with maintainers; [
      lovek323
      veprbl
    ];
  };
}
