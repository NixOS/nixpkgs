{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  boost,
  freetype,
  ftgl,
  libGLU,
  libGL,
  python,
}:

let

  pythonVersion = with lib.versions; "${major python.version}${minor python.version}";
in

buildPythonPackage rec {
  pname = "pyftgl";
  version = "0.4b";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "pyftgl";
    rev = "refs/tags/${version}";
    sha256 = "sha256-mbzXpIPMNe6wfwaAAw/Ri8xaW6Z6kuNUhFFyzsiW7Is=";
  };

  postPatch =
    ''
      sed -i "s,'boost_python','boost_python${pythonVersion}',g" setup.py
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      export NIX_CFLAGS_COMPILE+=" -L$SDKROOT/System/Library/Frameworks/OpenGL.framework/Versions/Current/Libraries"
    '';

  buildInputs = [
    boost
    freetype
    ftgl
    libGLU
    libGL
  ];

  meta = with lib; {
    description = "Python bindings for FTGL (FreeType for OpenGL)";
    license = licenses.gpl2Plus;
  };
}
