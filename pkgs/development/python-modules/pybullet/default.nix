{ lib
, buildPythonPackage
, fetchPypi
, libGLU_combined
, xorg
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "2.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ffeb00f393dcddc11d195a72623e3b06767a37e4fdfa06ef88fbd74c8d326adb";
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
