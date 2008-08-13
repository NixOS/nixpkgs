{ fetchurl, stdenv, python, setuptools, mesa, freeglut, pil }:

let version = "3.0.0b5";
in
  stdenv.mkDerivation {
    name = "pyopengl-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/pyopengl/PyOpenGL-${version}.tar.gz";
      sha256 = "1rjpl2qdcqn4wamkik840mywdycd39q8dn3wqfaiv35jdsbifxx3";
    };

    # Note: We need `ctypes', available in Python 2.5+.
    buildInputs = [ python ];
    propagatedBuildInputs = [ setuptools mesa freeglut pil ];

    configurePhase = "ensureDir $out/lib/python2.5/site-packages";
    buildPhase     = "python setup.py build";

    installPhase   = ''
      PYTHONPATH="$out/lib/python2.5/site-packages:$PYTHONPATH" \
      python setup.py install --prefix=$out
    '';

    meta = {
      homepage = http://pyopengl.sourceforge.net/;
      description = "PyOpenGL, the Python OpenGL bindings";

      longDescription = ''
        PyOpenGL is the cross platform Python binding to OpenGL and
        related APIs.  The binding is created using the standard (in
        Python 2.5) ctypes library, and is provided under an extremely
        liberal BSD-style Open-Source license.
      '';

      license = "BSD-style";
    };
  }
