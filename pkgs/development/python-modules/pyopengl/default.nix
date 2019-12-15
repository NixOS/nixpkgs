{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, pillow
}:

buildPythonPackage rec {
  pname = "pyopengl";
  version = "3.1.4";

  src = fetchPypi {
    pname = "PyOpenGL";
    inherit version;
    sha256 = "0bdf5ed600df30c8830455702338902528717c0af85ac5914f1dc5aa0bfa6eee";
  };

  propagatedBuildInputs = [ pkgs.libGLU pkgs.libGL pkgs.freeglut pillow ];

  patchPhase = let
    ext = stdenv.hostPlatform.extensions.sharedLibrary; in ''
    substituteInPlace OpenGL/platform/glx.py \
      --replace "'GL'" "'${pkgs.libGL}/lib/libGL${ext}'" \
      --replace "'GLU'" "'${pkgs.libGLU}/lib/libGLU${ext}'" \
      --replace "'glut'" "'${pkgs.freeglut}/lib/libglut${ext}'"
    substituteInPlace OpenGL/platform/darwin.py \
      --replace "'OpenGL'" "'${pkgs.libGL}/lib/libGL${ext}'" \
      --replace "'GLUT'" "'${pkgs.freeglut}/lib/libglut${ext}'"
  '';

  # Need to fix test runner
  # Tests have many dependencies
  # Extension types could not be found.
  # Should run test suite from $out/${python.sitePackages}
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://pyopengl.sourceforge.net/;
    description = "PyOpenGL, the Python OpenGL bindings";
    longDescription = ''
      PyOpenGL is the cross platform Python binding to OpenGL and
      related APIs.  The binding is created using the standard (in
      Python 2.5) ctypes library, and is provided under an extremely
      liberal BSD-style Open-Source license.
    '';
    license = "BSD-style";
    platforms = platforms.mesaPlatforms;
  };


}
