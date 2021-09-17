{ lib, stdenv, fetchPypi, writeText, python, buildPythonPackage, pycairo, backports_functools_lru_cache
, which, cycler, python-dateutil, nose, numpy, pyparsing, sphinx, tornado, kiwisolver
, freetype, libpng, pkg-config, mock, pytz, pygobject3, gobject-introspection, functools32, subprocess32
, fetchpatch
, enableGhostscript ? false, ghostscript, gtk3
, enableGtk3 ? false, cairo
# darwin has its own "MacOSX" backend
, enableTk ? !stdenv.isDarwin, tcl, tk, tkinter, libX11
, enableQt ? false, pyqt4
, Cocoa
, pythonOlder
}:

buildPythonPackage rec {
  version = "2.2.3";
  pname = "matplotlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7355bf757ecacd5f0ac9dd9523c8e1a1103faadf8d33c22664178e17533f8ce5";
  };

  patches = [
    # https://github.com/matplotlib/matplotlib/pull/12478
    (fetchpatch {
      name = "numpy-1.16-compat.patch";
      url = "https://github.com/matplotlib/matplotlib/commit/2980184d092382a40ab21f95b79582ffae6e19d6.patch";
      sha256 = "1c0wj28zy8s5h6qiavx9zzbhlmhjwpzbc3fyyw9039mbnqk0spg2";
    })
  ];

  XDG_RUNTIME_DIR = "/tmp";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ which sphinx ]
    ++ lib.optional enableGhostscript ghostscript
    ++ lib.optional stdenv.isDarwin [ Cocoa ];

  propagatedBuildInputs =
    [ cycler python-dateutil nose numpy pyparsing tornado freetype kiwisolver
      libpng mock pytz ]
    ++ lib.optional (pythonOlder "3.3") backports_functools_lru_cache
    ++ lib.optionals enableGtk3 [ cairo pycairo gtk3 gobject-introspection pygobject3 ]
    ++ lib.optionals enableTk [ tcl tk tkinter libX11 ]
    ++ lib.optionals enableQt [ pyqt4 ]
    ++ lib.optionals python.isPy2 [ functools32 subprocess32 ];

  passthru.config = {
    directories = { basedirlist = "."; };
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
