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
    repo = "${pname}-${version}";
    rev = version;
    sha256 = "12zcjv4cwwjihiaf74kslrdmmk4bs47h7006gyqfwdfchfjdgg4r";
  };

  postPatch = ''
    sed -i "s,'boost_python','boost_python${pythonVersion}',g" setup.py
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-L${libGL}/Library/Frameworks/OpenGL.framework/Versions/Current/Libraries";
  };

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
