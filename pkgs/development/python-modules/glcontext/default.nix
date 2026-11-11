{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  libGL,
  libx11,
}:

buildPythonPackage rec {
  pname = "glcontext";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = "glcontext";
    tag = version;
    hash = "sha256-9Tib0srQDm40ERDRGYFuaSEA9+sdUECWILtBWmZccOQ=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    libGL
    libx11
  ];

  postPatch = lib.optionalString (stdenv.hostPlatform.isLinux) ''
    substituteInPlace glcontext/x11.cpp \
      --replace-fail '"libGL.so"' '"${libGL}/lib/libGL.so"' \
      --replace-fail '"libX11.so"' '"${libx11}/lib/libX11.so"'
    substituteInPlace glcontext/egl.cpp \
      --replace-fail '"libGL.so"' '"${libGL}/lib/libGL.so"' \
      --replace-fail '"libEGL.so"' '"${libGL}/lib/libEGL.so"'
  '';

  # Tests fail because they try to open display. See
  # https://github.com/NixOS/nixpkgs/pull/121439
  # for details.
  doCheck = false;

  pythonImportsCheck = [ "glcontext" ];

  meta = {
    homepage = "https://github.com/moderngl/glcontext";
    description = "OpenGL implementation for ModernGL";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
}
