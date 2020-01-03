{ lib
, buildPythonPackage
, fetchPypi
, libGLU, libGL
, xorg
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6da064687ae481c73b744b9f3a62d8231349a6bf368d7a2e564f71ef73e9403";
  };

  buildInputs = [
    libGLU libGL
    xorg.libX11
  ];

  patches = [
    # make sure X11 and OpenGL can be found at runtime
    ./static-libs.patch
  ];

  meta = with lib; {
    description = "Open-source software for robot simulation, integrated with OpenAI Gym";
    homepage = https://pybullet.org/;
    license = licenses.zlib;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.linux;
  };
}
