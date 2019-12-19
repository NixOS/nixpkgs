{ lib
, buildPythonPackage
, fetchPypi
, libGLU, libGL
, xorg
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "2.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5824e902e0dd8bf7177ce5d9e038c6b04be65f72621fe13f93ec15c9d9c85a49";
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
