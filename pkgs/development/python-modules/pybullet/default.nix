{ lib
, buildPythonPackage
, fetchPypi
, libGLU_combined
, xorg
}:

buildPythonPackage rec {
  pname = "pybullet";
  version = "2.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b6dkrac5zydxqfrf827xhamsimychrn77dsfnz1kf7c1crlwcw9";
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
