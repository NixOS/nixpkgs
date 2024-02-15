{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, libGLU, libGL
, xorg
, numpy
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "3.2.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2idSVDPIhpjcn9i8IPpK5NB3OLRlZjNlnr2CwtKITgg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    downloadPage = "https://github.com/bulletphysics/bullet3";
    homepage = "https://pybullet.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.linux;
  };
}
