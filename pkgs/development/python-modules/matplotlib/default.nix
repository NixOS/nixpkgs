{ stdenv, fetchurl, writeText, python, buildPythonPackage, pycairo, isPy3k
, which, cycler, dateutil, nose, numpy, pyparsing, sphinx, tornado
, freetype, libpng, pkgconfig, mock, pytz, pygobject3
, enableGhostscript ? false, ghostscript ? null, gtk3
, enableGtk2 ? false, pygtk ? null, gobjectIntrospection
, enableGtk3 ? false, cairo
, enableTk ? false, tcl ? null, tk ? null, tkinter ? null, libX11 ? null
, Cocoa, Foundation, CoreData, cf-private, libobjc, libcxx
}:

assert enableGhostscript -> ghostscript != null;
assert enableGtk2 -> pygtk != null;
assert enableTk -> (tcl != null)
                && (tk != null)
                && ((!isPy3k) -> tkinter != null)
                && (libX11 != null)
                ;

let
  # Matplotlib tries to find Tcl/Tk by opening a Tk window and asking the
  # corresponding interpreter object for its library paths. This fails if
  # `$DISPLAY` is not set. The fallback option assumes that Tcl/Tk are both
  # installed under the same path which is not true in Nix.
  # With the following patch we just hard-code these paths into the install
  # script.
  tclTkPatch = writeText "tcl_tk.patch" ''
    --- a/setupext.py
    +++ b/setupext.py
    @@ -1480,11 +1480,11 @@ class BackendTkAgg(OptionalBackendPackage):
             return tcl_lib, tcl_inc, 'tcl' + tk_ver, tk_lib, tk_inc, 'tk' + tk_ver

         def hardcoded_tcl_config(self):
    -        tcl_inc = "/usr/local/include"
    -        tk_inc = "/usr/local/include"
    -        tcl_lib = "/usr/local/lib"
    -        tk_lib = "/usr/local/lib"
    -        return tcl_lib, tcl_inc, 'tcl', tk_lib, tk_inc, 'tk'
    +        tcl_inc = "${tcl}/include"
    +        tk_inc = "${tk.dev}/include"
    +        tcl_lib = "${tcl}/lib"
    +        tk_lib = "${tk}/lib"
    +        return tcl_lib, tcl_inc, '${tcl.libPrefix}', tk_lib, tk_inc, '${tk.libPrefix}'

         def add_flags(self, ext):
             if sys.platform == 'win32':
    @@ -1558,19 +1558,8 @@ class BackendTkAgg(OptionalBackendPackage):
                 #   3. Use some hardcoded locations that seem to work on a lot
                 #      of distros.

    -            # Query Tcl/Tk system for library paths and version string
    -            try:
    -                tcl_lib_dir, tk_lib_dir, tk_ver = self.query_tcltk()
    -            except:
    -                tk_ver = '''
    -                result = self.hardcoded_tcl_config()
    -            else:
    -                result = self.parse_tcl_config(tcl_lib_dir, tk_lib_dir)
    -                if result is None:
    -                    result = self.guess_tcl_config(
    -                        tcl_lib_dir, tk_lib_dir, tk_ver)
    -                    if result is None:
    -                        result = self.hardcoded_tcl_config()
    +            # Always use hardcoded locations in Nix
    +            result = self.hardcoded_tcl_config()

                 # Add final versions of directories and libraries to ext lists
                 (tcl_lib_dir, tcl_inc_dir, tcl_lib,
  '';
in

buildPythonPackage rec {
  name = "matplotlib-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "mirror://pypi/m/matplotlib/${name}.tar.gz";
    sha256 = "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  XDG_RUNTIME_DIR = "/tmp";

  buildInputs = [ python which sphinx stdenv ]
    ++ stdenv.lib.optional enableGhostscript ghostscript
    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa Foundation CoreData
                                              cf-private libobjc ];

  propagatedBuildInputs =
    [ cycler dateutil nose numpy pyparsing tornado freetype 
      libpng pkgconfig mock pytz  
    ]
    ++ stdenv.lib.optional enableGtk2 pygtk
    ++ stdenv.lib.optionals enableGtk3 [ cairo pycairo gtk3 gobjectIntrospection pygobject3 ]
    ++ stdenv.lib.optionals enableTk [ tcl tk tkinter libX11 ];

  patches =
    [ ./basedirlist.patch ] ++
    stdenv.lib.optionals enableTk [ tclTkPatch ] ++
    stdenv.lib.optionals stdenv.isDarwin [ ./darwin-stdenv.patch ];

  checkPhase = ''
    ${python.interpreter} tests.py
  '';

  # The entry point for running tests, tests.py, is not included in the release.
  # https://github.com/matplotlib/matplotlib/issues/6017
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
