{ lib
, buildPythonPackage
, fetchPypi
, libGLU, libGL
, xorg
, numpy
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "3.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7e6c7c77cab39e1559c98e4290c5138247b15d3a26a76a23b2737c159f3f905";
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
