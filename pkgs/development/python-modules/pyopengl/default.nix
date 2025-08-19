{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pkgs,
  pillow,
  mesa,
}:

buildPythonPackage rec {
  pname = "pyopengl";
  version = "3.1.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KOvYLF9EkaQYrsqWct/7Otvn0zs56tpFSKW06MA/YMg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  patchPhase =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      # Theses lines are patching the name of dynamic libraries
      # so pyopengl can find them at runtime.
      substituteInPlace OpenGL/platform/glx.py \
        --replace-fail "'OpenGL'"  '"${pkgs.libGL}/lib/libOpenGL${ext}"' \
        --replace-fail '"GL",' '"${pkgs.libGL}/lib/libGL${ext}",' \
        --replace-fail "'GL'"  '"${pkgs.libGL}/lib/libGL${ext}"' \
        --replace-fail '"GLU",' '"${pkgs.libGLU}/lib/libGLU${ext}",' \
        --replace-fail "'GLX'" '"${pkgs.libglvnd}/lib/libGLX${ext}"' \
        --replace-fail '"glut",' '"${pkgs.libglut}/lib/libglut${ext}",' \
        --replace-fail '"GLESv1_CM",' '"${pkgs.libGL}/lib/libGLESv1_CM${ext}",' \
        --replace-fail '"GLESv2",' '"${pkgs.libGL}/lib/libGLESv2${ext}",' \
        --replace-fail '"gle",' '"${pkgs.gle}/lib/libgle${ext}",' \
        --replace-fail "'EGL'" "'${pkgs.libGL}/lib/libEGL${ext}'"
      substituteInPlace OpenGL/platform/egl.py \
        --replace-fail "('OpenGL','GL')" "('${pkgs.libGL}/lib/libOpenGL${ext}', '${pkgs.libGL}/lib/libGL${ext}')" \
        --replace-fail "'GLU'," "'${pkgs.libGLU}/lib/libGLU${ext}'," \
        --replace-fail "'glut'," "'${pkgs.libglut}/lib/libglut${ext}'," \
        --replace-fail "'GLESv1_CM'," "'${pkgs.libGL}/lib/libGLESv1_CM${ext}'," \
        --replace-fail "'GLESv2'," "'${pkgs.libGL}/lib/libGLESv2${ext}'," \
        --replace-fail "'gle'," '"${pkgs.gle}/lib/libgle${ext}",' \
        --replace-fail "'EGL'," "'${pkgs.libGL}/lib/libEGL${ext}',"
      substituteInPlace OpenGL/platform/darwin.py \
        --replace-fail "'OpenGL'," "'${pkgs.libGL}/lib/libGL${ext}'," \
        --replace-fail "'GLUT'," "'${pkgs.libglut}/lib/libglut${ext}',"
    ''
    + ''
      # https://github.com/NixOS/nixpkgs/issues/76822
      # pyopengl introduced a new "robust" way of loading libraries in 3.1.4.
      # The later patch of the filepath does not work anymore because
      # pyopengl takes the "name" (for us: the path) and tries to add a
      # few suffix during its loading phase.
      # The following patch put back the "name" (i.e. the path) in the
      # list of possible files.
      substituteInPlace OpenGL/platform/ctypesloader.py \
        --replace-fail "filenames_to_try = [base_name]" "filenames_to_try = [name]"
    '';

  # Need to fix test runner
  # Tests have many dependencies
  # Extension types could not be found.
  # Should run test suite from $out/${python.sitePackages}
  doCheck = false; # does not affect pythonImportsCheck

  # OpenGL looks for libraries during import, making this a somewhat decent test of the flaky patching above.
  pythonImportsCheck = [
    "OpenGL"
    "OpenGL.GL"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "OpenGL.GLX"
  ];

  meta = with lib; {
    homepage = "https://mcfletch.github.io/pyopengl/";
    description = "PyOpenGL, the Python OpenGL bindings";
    longDescription = ''
      PyOpenGL is the cross platform Python binding to OpenGL and
      related APIs.  The binding is created using the standard (in
      Python 2.5) ctypes library, and is provided under an extremely
      liberal BSD-style Open-Source license.
    '';
    license = licenses.bsd3;
    inherit (mesa.meta) platforms;
  };
}
