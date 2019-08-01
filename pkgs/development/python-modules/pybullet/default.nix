{ lib
, buildPythonPackage
, fetchPypi
, libGLU_combined
, xorg
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "2.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bcb5aaca2b8adf94a04fd5206eea113ddc1993c9f13ab39f4a37e98f92b6d7db";
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
