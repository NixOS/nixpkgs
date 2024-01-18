{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, libGL
, libX11
}:

buildPythonPackage rec {
  pname = "glcontext";
  version = "2.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ld+INKIGDZA2Y+sTxDPY7MI1nru6x+FeixngaJQzKkg=";
  };

  disabled = !isPy3k;

  buildInputs = [ libGL libX11 ];

  postPatch = ''
    substituteInPlace glcontext/x11.cpp \
      --replace '"libGL.so"' '"${libGL}/lib/libGL.so"' \
      --replace '"libX11.so"' '"${libX11}/lib/libX11.so"'
    substituteInPlace glcontext/egl.cpp \
      --replace '"libGL.so"' '"${libGL}/lib/libGL.so"' \
      --replace '"libEGL.so"' '"${libGL}/lib/libEGL.so"'
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
    maintainers = with maintainers; [ friedelino ];
  };
}
