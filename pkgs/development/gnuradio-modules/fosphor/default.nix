{ lib
, mkDerivation
, fetchFromGitea
, gnuradio
, cmake
, pkg-config
, logLib
, mpir
, gmp
, boost
, libGL
, opencl-headers
, ocl-icd
, freetype
, fftwFloat
, libX11
, qt5
, python
, enableGLFW ? true, glfw3
, enablePNG ? true, libpng
, gnuradioOlder
, gnuradioAtLeast
}:

mkDerivation {
  pname = "gr-fosphor";
  version = "unstable-2023-08-26";
  src = fetchFromGitea {
    domain = "gitea.osmocom.org";
    owner = "sdr";
    repo = "gr-fosphor";
    rev = "e02a2ea4936324379b02c5a1d4878b2da0961bd9";
    hash = "sha256-nJEwWBZep5KX8eF+yA8QxDk07pcO7l3OSmKxXAU8KCs=";
  };
  disabled = gnuradioOlder "3.9" || gnuradioAtLeast "3.11";

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals (gnuradio.hasFeature "gr-qtgui") [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    logLib
    mpir
    gmp
    boost
    libGL
    opencl-headers
    ocl-icd
    freetype
    fftwFloat
  ] ++ lib.optionals (gnuradio.hasFeature "gr-qtgui") [
    qt5.qtbase
  ] ++ lib.optionals (gnuradio.hasFeature "python-support") [
    python.pkgs.pybind11
    python.pkgs.numpy
  ] ++ lib.optionals enableGLFW [
    glfw3
  ] ++ lib.optionals enablePNG [
    libpng
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" (gnuradio.hasFeature "gr-qtgui"))
    (lib.cmakeBool "ENABLE_PYTHON" (gnuradio.hasFeature "python-support"))
    (lib.cmakeBool "ENABLE_GLFW" enableGLFW)
    (lib.cmakeBool "ENABLE_PNG" enablePNG)
  ];

  meta = with lib; {
    description = "GNU Radio block for RTSA-like spectrum visualization using OpenCL and OpenGL acceleration";
    longDescription = ''
      You'll need to install an OpenCL ICD for it to work.
      See https://nixos.org/manual/nixos/stable/#sec-gpu-accel-opencl
    '';
    homepage = "https://projects.osmocom.org/projects/sdr/wiki/Fosphor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
