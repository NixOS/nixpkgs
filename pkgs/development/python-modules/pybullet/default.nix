{ lib
, buildPythonPackage
, fetchPypi
, libGLU, libGL
, xorg
, numpy
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df02fb0ab74a6e7c4e1d7a3e2ffd7e4760a30cdeccb9fa6dd19f334122ec00f2";
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
