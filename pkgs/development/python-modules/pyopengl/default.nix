{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, pillow
}:

buildPythonPackage rec {
  pname = "pyopengl";
  version = "3.1.6";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyOpenGL";
    inherit version;
    hash = "sha256-jqbIdzkn7adAW//G9buTvoFWmnsFyMrFDNlOlp3OXic=";
  };

  propagatedBuildInputs = [ pillow ];

  patchPhase = let
    ext = stdenv.hostPlatform.extensions.sharedLibrary; in lib.optionalString (!stdenv.isDarwin) ''
    # Theses lines are patching the name of dynamic libraries
    # so pyopengl can find them at runtime.
    substituteInPlace OpenGL/platform/glx.py \
      --replace "'GL'" "'${pkgs.libGL}/lib/libGL${ext}'" \
      --replace "'GLU'" "'${pkgs.libGLU}/lib/libGLU${ext}'" \
      --replace "'glut'" "'${pkgs.freeglut}/lib/libglut${ext}'" \
      --replace "'GLESv1_CM'," "'${pkgs.libGL}/lib/libGLESv1_CM${ext}'," \
      --replace "'GLESv2'," "'${pkgs.libGL}/lib/libGLESv2${ext}',"
    substituteInPlace OpenGL/platform/egl.py \
      --replace "('OpenGL','GL')" "('${pkgs.libGL}/lib/libOpenGL${ext}', '${pkgs.libGL}/lib/libGL${ext}')" \
      --replace "'GLU'," "'${pkgs.libGLU}/lib/libGLU${ext}'," \
      --replace "'glut'," "'${pkgs.freeglut}/lib/libglut${ext}'," \
      --replace "'GLESv1_CM'," "'${pkgs.libGL}/lib/libGLESv1_CM${ext}'," \
      --replace "'GLESv2'," "'${pkgs.libGL}/lib/libGLESv2${ext}'," \
      --replace "'EGL'," "'${pkgs.libGL}/lib/libEGL${ext}',"
    substituteInPlace OpenGL/platform/darwin.py \
      --replace "'OpenGL'," "'${pkgs.libGL}/lib/libGL${ext}'," \
      --replace "'GLUT'," "'${pkgs.freeglut}/lib/libglut${ext}',"
    # TODO: patch 'gle' in OpenGL/platform/egl.py
  '' + ''
    # https://github.com/NixOS/nixpkgs/issues/76822
    # pyopengl introduced a new "robust" way of loading libraries in 3.1.4.
    # The later patch of the filepath does not work anymore because
    # pyopengl takes the "name" (for us: the path) and tries to add a
    # few suffix during its loading phase.
    # The following patch put back the "name" (i.e. the path) in the
    # list of possible files.
    substituteInPlace OpenGL/platform/ctypesloader.py \
      --replace "filenames_to_try = []" "filenames_to_try = [name]"
  '';

  # Need to fix test runner
  # Tests have many dependencies
  # Extension types could not be found.
  # Should run test suite from $out/${python.sitePackages}
  doCheck = false; # does not affect pythonImportsCheck

  # OpenGL looks for libraries during import, making this a somewhat decent test of the flaky patching above.
  pythonImportsCheck = "OpenGL";

  meta = with lib; {
    homepage = "https://pyopengl.sourceforge.net/";
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
