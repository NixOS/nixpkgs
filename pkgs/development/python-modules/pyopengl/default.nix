{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mesa,
  pkgs,
  replaceVars,
  setuptools,
  stdenv,
  pytestCheckHook,
  pygame,
  psutil,
  xvfb,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyopengl";
  version = "3.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mcfletch";
    repo = "pyopengl";
    tag = finalAttrs.version;
    hash = "sha256-U/7J3EoxKHp/dR2LAzTiwR5wcjZbUBuT5Dt3c76xxj4=";
  };

  patches = lib.optionals (finalAttrs.passthru.runtimeLibs != [ ]) [
    # patch OpenGL.platform.ctypesloader::_loadLibraryPosix with extra search paths
    (replaceVars ./ld-preload-gl.patch {
      GL_LD_LIBRARY_PATH = lib.makeLibraryPath finalAttrs.passthru.runtimeLibs;
    })
  ];

  build-system = [ setuptools ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [
    xvfb
    mesa.llvmpipeHook
    pytestCheckHook
    pygame
    psutil
  ];

  # setup a virtual x11 display
  preCheck = ''
    export DISPLAY=:$((2000 + $RANDOM % 1000))
    Xvfb $DISPLAY -screen 5 1024x768x8 &
    xvfb_pid=$!
  '';
  postCheck = ''
    kill $xvfb_pid
  '';

  disabledTests = [
    # undefined symbol: glutSolidTeapot
    "test_check_glut_load"
    # gbmdevice is None
    "test_egl_ext_enumerate"
    # failed assertion: assert depth in (1, (1,))
    "test_glCallLists_twice2"
  ];

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

  passthru.runtimeLibs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "/run/opengl-driver"
    pkgs.libglvnd
    pkgs.libGLU
    pkgs.libglut
    pkgs.gle
  ];

  meta = {
    homepage = "https://mcfletch.github.io/pyopengl/";
    description = "PyOpenGL, the Python OpenGL bindings";
    longDescription = ''
      PyOpenGL is the cross platform Python binding to OpenGL and related APIs.
    '';
    license = lib.licenses.bsd3;
    inherit (mesa.meta) platforms;
  };
})
