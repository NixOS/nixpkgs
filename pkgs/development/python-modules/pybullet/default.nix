{ lib
, buildPythonPackage
, fetchPypi
, libGLU_combined
, xorg
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "2.5.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82a235a8fe3c8dee753d765c295ff0da92bcb5096209d26a0cfc3f5c6054e374";
  };

  buildInputs = [
    libGLU_combined
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
