{ lib
, buildPythonPackage
, fetchPypi
, libGLU, libGL
, xorg
, numpy
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "3.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47e55d2b0c565a968406f314faad7c002be6d8b0afc8ad2c437d07b7b7d2f590";
  };

  buildInputs = [
    libGLU libGL
    xorg.libX11
  ];

  propagatedBuildInputs =  [ numpy ];

  patches = [
    # make sure X11 and OpenGL can be found at runtime
    ./static-libs.patch
  ];

  meta = with lib; {
    description = "Open-source software for robot simulation, integrated with OpenAI Gym";
    homepage = "https://pybullet.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.linux;
  };
}
