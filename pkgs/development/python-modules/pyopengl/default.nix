{
  lib,
  stdenv,
  buildPythonPackage,
  replaceVars,
  fetchPypi,
  setuptools,
  pkgs,
  pillow,
  mesa,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyopengl";
  version = "3.1.10";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xKAtaGa1TrEZyOmz+wT6g1qVq4At2WYHq0zbABLfgzU=";
  };

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  passthru.runtimeLibs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "/run/opengl-driver/lib"
    pkgs.libglvnd
    pkgs.libGLU
    pkgs.libglut
    pkgs.gle
  ];

  patches = lib.optionals (finalAttrs.passthru.runtimeLibs != [ ]) [
    # patch OpenGL.platform.ctypesloader::_loadLibraryPosix with extra search paths
    (replaceVars ./ld-preload-gl.patch {
      GL_LD_LIBRARY_PATH = lib.makeLibraryPath finalAttrs.passthru.runtimeLibs;
    })
  ];

  # Need to fix test runner
  # Tests have many dependencies
  # Extension types could not be found.
  # Should run test suite from $out/${python.sitePackages}
  doCheck = false; # does not affect pythonImportsCheck

  # PyOpenGL looks for libraries during import, making this a somewhat decent test of our patching
  # (these are impure deps on darwin)
  pythonImportsCheck = [
    "OpenGL"
    "OpenGL.GL"
    "OpenGL.GLE"
    "OpenGL.GLU"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "OpenGL.EGL"
    "OpenGL.GLES1"
    "OpenGL.GLES2"
    "OpenGL.GLES3"
    "OpenGL.GLX"
  ];

  meta = {
    homepage = "https://mcfletch.github.io/pyopengl/";
    description = "PyOpenGL, the Python OpenGL bindings";
    longDescription = ''
      PyOpenGL is the cross platform Python binding to OpenGL and
      related APIs.  The binding is created using the standard (in
      Python 2.5) ctypes library, and is provided under an extremely
      liberal BSD-style Open-Source license.
    '';
    license = lib.licenses.bsd3;
    inherit (mesa.meta) platforms;
  };
})
