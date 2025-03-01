{
  lib,
  mkDerivation,
  fetchgit,
  gnuradio,
  cmake,
  pkg-config,
  logLib,
  mpir,
  gmp,
  boost,
  libGL,
  opencl-headers,
  ocl-icd,
  freetype,
  fftwFloat,
  qt5,
  python,
  enableGLFW ? true,
  glfw3,
  enablePNG ? true,
  libpng,
  gnuradioOlder,
  gnuradioAtLeast,
}:

mkDerivation {
  pname = "gr-fosphor";
  version = "unstable-2024-03-23";

  # It is a gitea instance, but its archive service doesn't work very well so
  # we can't use it.
  src = fetchgit {
    url = "https://gitea.osmocom.org/sdr/gr-fosphor.git";
    rev = "74d54fc0b3ec9aeb7033686526c5e766f36eaf24";
    hash = "sha256-FBmH4DmKATl0FPFU7T30OrYYmxlSTTLm1SZpt0o1qkw=";
  };
  disabled = gnuradioOlder "3.9" || gnuradioAtLeast "3.11";

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals (gnuradio.hasFeature "gr-qtgui") [
      qt5.wrapQtAppsHook
    ];

  buildInputs =
    [
      logLib
      mpir
      gmp
      boost
      libGL
      opencl-headers
      ocl-icd
      freetype
      fftwFloat
    ]
    ++ lib.optionals (gnuradio.hasFeature "gr-qtgui") [
      qt5.qtbase
    ]
    ++ lib.optionals (gnuradio.hasFeature "python-support") [
      python.pkgs.pybind11
      python.pkgs.numpy
    ]
    ++ lib.optionals enableGLFW [
      glfw3
    ]
    ++ lib.optionals enablePNG [
      libpng
    ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" (gnuradio.hasFeature "gr-qtgui"))
    (lib.cmakeBool "ENABLE_PYTHON" (gnuradio.hasFeature "python-support"))
    (lib.cmakeBool "ENABLE_GLFW" enableGLFW)
    (lib.cmakeBool "ENABLE_PNG" enablePNG)
  ];

  meta = {
    description = "GNU Radio block for RTSA-like spectrum visualization using OpenCL and OpenGL acceleration";
    longDescription = ''
      You'll need to install an OpenCL ICD for it to work.
      See https://nixos.org/manual/nixos/stable/#sec-gpu-accel-opencl
    '';
    homepage = "https://projects.osmocom.org/projects/sdr/wiki/Fosphor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.linux;
  };
}
