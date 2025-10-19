{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
  isPyPy,
  pythonAtLeast,
  pythonOlder,

  # build-system
  certifi,
  pkg-config,
  pybind11,
  meson-python,
  setuptools-scm,
  pytestCheckHook,
  python,
  matplotlib,
  fetchurl,

  # native libraries
  ffmpeg-headless,
  freetype,
  # By default, almost all tests fail due to the fact we use our version of
  # freetype. We still use this argument to define the overridden
  # derivation `matplotlib.passthru.tests.withoutOutdatedFreetype` - which
  # builds matplotlib with the freetype version they default to, with which all
  # tests should pass.
  doCheck ? false,
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
  # tkinter fails to build on Python 3.11
  enableTk ? (!stdenv.hostPlatform.isDarwin && !isPyPy && pythonAtLeast "3.12"),
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
  libX11,
  wayland,

  # Reverse dependency
  sage,
}:

let
  interactive = enableTk || enableGtk3 || enableQt;
in

buildPythonPackage rec {
  version = "3.10.5";
  pname = "matplotlib";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NS7WzPt5mKAIgWkvOLTKCDxpHT4nW0FFQjcEw0yQkHY=";
  };

  env.XDG_RUNTIME_DIR = "/tmp";

  # Matplotlib tries to find Tcl/Tk by opening a Tk window and asking the
  # corresponding interpreter object for its library paths. This fails if
  # `$DISPLAY` is not set. The fallback option assumes that Tcl/Tk are both
  # installed under the same path which is not true in Nix.
  # With the following patch we just hard-code these paths into the install
  # script.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "meson-python>=0.13.1,<0.17.0" meson-python

    patchShebangs tools
  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux && interactive) ''
    # fix paths to libraries in dlopen calls (headless detection)
    substituteInPlace src/_c_internal_utils.cpp \
      --replace-fail libX11.so.6 ${libX11}/lib/libX11.so.6 \
      --replace-fail libwayland-client.so.0 ${wayland}/lib/libwayland-client.so.0
  '';

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals enableGtk3 [ gobject-introspection ];

  buildInputs = [
    ffmpeg-headless
    freetype
    qhull
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
  ++ lib.optionals (pythonOlder "3.10") [ importlib-resources ]
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
    # Otherwise GNU's `ar` binary fails to put symbols from libagg into the
    # matplotlib shared objects. See:
    # -https://github.com/matplotlib/matplotlib/issues/28260#issuecomment-2146243663
    # -https://github.com/matplotlib/matplotlib/issues/28357#issuecomment-2155350739
    b_lto = false;
  };

  passthru.tests = {
    inherit sage;
    withOutdatedFreetype = matplotlib.override {
      doCheck = true;
      freetype = freetype.overrideAttrs (_: {
        src = fetchurl {
          url = "mirror://savannah/freetype/freetype-old/freetype-2.6.1.tar.gz";
          hash = "sha256-Cjx9+9ptoej84pIy6OltmHq6u79x68jHVlnkEyw2cBQ=";
        };
        patches = [ ];
      });
    };
  };

  pythonImportsCheck = [ "matplotlib" ];
  inherit doCheck;
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
