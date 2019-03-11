{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, pillow
}:

buildPythonPackage rec {
  pname = "pyopengl";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b47c5c3a094fa518ca88aeed35ae75834d53e4285512c61879f67a48c94ddaf";
  };

  propagatedBuildInputs = [ pkgs.libGLU_combined pkgs.freeglut pillow ];

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
