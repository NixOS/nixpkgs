{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, boost, freetype, ftgl, libGLU_combined
, python
}:

let

  pythonVersion = with lib.versions; "${major python.version}${minor python.version}";

in

buildPythonPackage rec {
  pname = "pyftgl";
  version = "0.4b";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = name;
    rev = version;
    sha256 = "12zcjv4cwwjihiaf74kslrdmmk4bs47h7006gyqfwdfchfjdgg4r";
  };

  postPatch = ''
    sed -i "s,'boost_python','boost_python${pythonVersion}',g" setup.py
  '';

  buildInputs = [ boost freetype ftgl libGLU_combined ];

  meta = with lib; {
    description = "Python bindings for FTGL (FreeType for OpenGL)";
    license = licenses.gpl2Plus;
  };
}
