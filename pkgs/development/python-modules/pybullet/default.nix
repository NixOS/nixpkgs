{ lib
, buildPythonPackage
, fetchPypi
, libGLU, libGL
, xorg
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a75a4fc828f59a538e6b6381cfb37019193829beca4da2acf8cd0a749cf63b8";
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
