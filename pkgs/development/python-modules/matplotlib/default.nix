{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
  isPyPy,

  # build-system
  certifi,
  pkg-config,
  pybind11,
  meson-python,
  setuptools-scm,
  pytestCheckHook,
  python,

  # native libraries
  ffmpeg-headless,
  freetype,
  qhull,
  libraqm,

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

  # GTK3
  enableGtk3 ? false,
  cairo,
  gobject-introspection,
  gtk3,
  pycairo,
  pygobject3,

  # Tk
  # Darwin has its own "MacOSX" backend, PyPy has tkagg backend and does not support tkinter
  enableTk ? (!stdenv.hostPlatform.isDarwin && !isPyPy),
  tkinter,

  # Qt
  enableQt ? false,
  pyqt5,

  # Webagg
  enableWebagg ? false,
  tornado,

  # nbagg
  enableNbagg ? false,
  ipykernel,

  # required for headless detection
  libx11,
  wayland,

  # Reverse dependency
  sage,
}:

let
  interactive = enableTk || enableGtk3 || enableQt;
in

buildPythonPackage (finalAttrs: {
  version = "3.11.0";
  pname = "matplotlib";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-aMDHvgGzDcyjY4k09/WR33NAEjXL2/DRqxxx59t/i1c=";
  };

  env.XDG_RUNTIME_DIR = "/tmp";

  # Matplotlib tries to find Tcl/Tk by opening a Tk window and asking the
  # corresponding interpreter object for its library paths. This fails if
  # `$DISPLAY` is not set. The fallback option assumes that Tcl/Tk are both
  # installed under the same path which is not true in Nix.
  # With the following patch we just hard-code these paths into the install
  # script.
  postPatch =
    lib.optionalString isPyPy ''
      substituteInPlace tools/generate_matplotlibrc.py \
        --replace-fail "/usr/bin/env python3" "/usr/bin/env pypy3"
    ''
    + ''
      substituteInPlace pyproject.toml \
        --replace-fail "setuptools_scm>=7,<10" setuptools_scm

      patchShebangs tools
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux && interactive) ''
      # fix paths to libraries in dlopen calls (headless detection)
      substituteInPlace src/_c_internal_utils.cpp \
        --replace-fail libX11.so.6 ${libx11}/lib/libX11.so.6 \
        --replace-fail libwayland-client.so.0 ${wayland}/lib/libwayland-client.so.0
    '';

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals enableGtk3 [ gobject-introspection ];

  buildInputs = [
    ffmpeg-headless
    freetype
    qhull
    libraqm
  ]
  ++ lib.optionals enableGtk3 [
    cairo
    gtk3
  ];

  # clang-11: error: argument unused during compilation: '-fno-strict-overflow' [-Werror,-Wunused-command-line-argument]
  hardeningDisable = lib.optionals stdenv.hostPlatform.isDarwin [ "strictoverflow" ];

  build-system = [
    certifi
    numpy
    pybind11
    meson-python
    setuptools-scm
  ];

  dependencies = [
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
  ++ lib.optionals enableGtk3 [
    pycairo
    pygobject3
  ]
  ++ lib.optionals enableQt [ pyqt5 ]
  ++ lib.optionals enableWebagg [ tornado ]
  ++ lib.optionals enableNbagg [ ipykernel ]
  ++ lib.optionals enableTk [ tkinter ];

  mesonFlags = lib.mapAttrsToList lib.mesonBool {
    system-freetype = true;
    system-qhull = true;
    system-libraqm = true;
    # Otherwise GNU's `ar` binary fails to put symbols from libagg into the
    # matplotlib shared objects. See:
    # -https://github.com/matplotlib/matplotlib/issues/28260#issuecomment-2146243663
    # -https://github.com/matplotlib/matplotlib/issues/28357#issuecomment-2155350739
    b_lto = false;
  };

  passthru.tests = {
    inherit sage;
  };

  pythonImportsCheck = [ "matplotlib" ];
  # Running the tests requires a specific freetype version, so pixel-to-pixel
  # comparisons will pass. Since matplotlib depends directly & indirectly on
  # freetype, this would be too expensive to even test this (correctly) in
  # `passthru.tests`.
  doCheck = false;
  nativeCheckInputs = [ pytestCheckHook ];
  preCheck = ''
    # https://matplotlib.org/devdocs/devel/testing.html#obtain-the-reference-images
    find lib -name baseline_images -printf '%P\n' | while read p; do
      cp -r lib/"$p" $out/${python.sitePackages}/"$p"
    done
    # Tests will fail without these files as well
    cp \
      lib/matplotlib/tests/{mpltest.ttf,cmr10.pfb,Courier10PitchBT-Bold.pfb} \
      $out/${python.sitePackages}/matplotlib/tests/
    # https://github.com/NixOS/nixpkgs/issues/255262
    cd $out
  '';

  meta = {
    description = "Python plotting library, making publication quality plots";
    homepage = "https://matplotlib.org/";
    changelog = "https://github.com/matplotlib/matplotlib/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      psfl
      bsd0
    ];
    maintainers = with lib.maintainers; [
      veprbl
      doronbehar
    ];
  };
})
