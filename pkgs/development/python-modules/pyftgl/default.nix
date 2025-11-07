{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  setuptools,
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
  pyproject = true;

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "pyftgl";
    tag = version;
    sha256 = "sha256-mbzXpIPMNe6wfwaAAw/Ri8xaW6Z6kuNUhFFyzsiW7Is=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail boost_python boost_python${pythonVersion}
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

  meta = {
    description = "Python bindings for FTGL (FreeType for OpenGL)";
    license = lib.licenses.gpl2Plus;
  };
}
