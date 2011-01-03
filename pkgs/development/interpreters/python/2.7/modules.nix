{ stdenv, python, sqlite, tcl, tk, x11, openssl, readline }:

with stdenv.lib;

let 

  buildInternalPythonModule =
    { moduleName
    , internalName ? "_" + moduleName
    , deps
    }:
    stdenv.mkDerivation rec {
      name = "python-${moduleName}-${python.version}";

      src = python.src;

      patches = python.patches;

      buildInputs = [ python ] ++ deps;

      C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
      LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);

      configurePhase = "true";

      buildPhase =
        ''
          # Fake the build environment that setup.py expects.
          ln -s ${python}/include/python*/pyconfig.h .
          ln -s ${python}/lib/python*/config/Setup Modules/
          ln -s ${python}/lib/python*/config/Setup.local Modules/

          substituteInPlace setup.py --replace 'self.extensions = extensions' \
            'self.extensions = [ext for ext in self.extensions if ext.name in ["${internalName}"]]'

          python ./setup.py build_ext
        '';

      installPhase =
        ''
          dest=$out/lib/${python.libPrefix}/site-packages
          mkdir -p $dest
          cp -p $(find . -name "*.so") $dest/
        '';
    };

in {
    
  sqlite3 = buildInternalPythonModule {
    moduleName = "sqlite3";
    deps = [ sqlite ];
  };
    
  tkinter = buildInternalPythonModule {
    moduleName = "tkinter";
    deps = [ tcl tk x11 ];
  };
    
  ssl = buildInternalPythonModule {
    moduleName = "ssl";
    deps = [ openssl ];
  };
    
  readline = buildInternalPythonModule {
    moduleName = "readline";
    internalName = "readline";
    deps = [ readline ];
  };
    
}
