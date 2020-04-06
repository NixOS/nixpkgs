{ lib
, buildPythonPackage
, fetchPypi
, libGLU, libGL
, xorg
, numpy
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "2.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lsvjqij1vb9w8j6lvnq7lppflc7svz4cj37n74q67mb46gq3dxr";
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
    homepage = https://pybullet.org/;
    license = licenses.zlib;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.linux;
  };
}
