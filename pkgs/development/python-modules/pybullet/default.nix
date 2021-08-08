{ lib
, buildPythonPackage
, fetchPypi
, libGLU, libGL
, xorg
, numpy
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "3.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c343b90c4f3d529a0fbee8bec2b3e35d444f32e92d5ce974fe590544360fe310";
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
