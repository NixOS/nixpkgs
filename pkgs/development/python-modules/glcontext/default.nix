{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  libGL,
  libX11,
}:

buildPythonPackage rec {
  pname = "glcontext";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = "glcontext";
    rev = "refs/tags/${version}";
    hash = "sha256-GC2sb6xQjg99xLcXSynLOOyyqNwCHZwZqrs9RZh99pY=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    libGL
    libX11
  ];

  postPatch = ''
    substituteInPlace glcontext/x11.cpp \
      --replace-fail '"libGL.so"' '"${libGL}/lib/libGL.so"' \
      --replace-fail '"libX11.so"' '"${libX11}/lib/libX11.so"'
    substituteInPlace glcontext/egl.cpp \
      --replace-fail '"libGL.so"' '"${libGL}/lib/libGL.so"' \
      --replace-fail '"libEGL.so"' '"${libGL}/lib/libEGL.so"'
  '';

  # Tests fail because they try to open display. See
  # https://github.com/NixOS/nixpkgs/pull/121439
  # for details.
  doCheck = false;

  pythonImportsCheck = [ "glcontext" ];

  meta = with lib; {
    homepage = "https://github.com/moderngl/glcontext";
    description = "OpenGL implementation for ModernGL";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
