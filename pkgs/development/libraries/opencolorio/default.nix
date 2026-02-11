{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  expat,
  yaml-cpp,
  pystring,
  imath,
  minizip-ng,
  zlib,
  # Only required on Linux
  glew,
  libglut,
  # Python bindings
  pythonBindings ? true, # Python bindings
  python3Packages,
  # Build apps
  buildApps ? true, # Utility applications
  lcms2,
  openexr,
}:

stdenv.mkDerivation rec {
  pname = "opencolorio";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenColorIO";
    rev = "v${version}";
    hash = "sha256-iI32dnGZdizLBOs7IQtmLUYMPWxadvWNeqZjy49AWb0=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # these tests don't like being run headless on darwin. no builtin
    # way of skipping tests so this is what we're reduced to.
    substituteInPlace tests/cpu/Config_tests.cpp \
      --replace-fail 'OCIO_ADD_TEST(Config, virtual_display)' 'static void _skip_virtual_display()' \
      --replace-fail 'OCIO_ADD_TEST(Config, virtual_display_with_active_displays)' 'static void _skip_virtual_display_with_active_displays()'

    # can't just use /tmp like that on macos
    substituteInPlace tests/cpu/UnitTestUtils.cpp \
      --replace-fail '"/tmp"' '"'"$(mktemp -d)"'"'
  '';

  nativeBuildInputs = [ cmake ] ++ lib.optionals pythonBindings [ python3Packages.python ];
  buildInputs = [
    expat
    yaml-cpp
    pystring
    imath
    minizip-ng
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glew
    libglut
  ]
  ++ lib.optionals pythonBindings [
    python3Packages.python
    python3Packages.pybind11
  ]
  ++ lib.optionals buildApps [
    lcms2
    openexr
  ];

  # Gcc blindly tries to optimize all float operations instead of just marked ones.
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=122304
  CXXFLAGS = "-ffp-contract=on";
  cmakeFlags = [
    "-DOCIO_INSTALL_EXT_PACKAGES=NONE"
    "-DOCIO_USE_SSE2NEON=OFF"
    # GPU test fails with: libglut (GPU tests): failed to open display ''
    "-DOCIO_BUILD_GPU_TESTS=OFF"
    "-Dminizip-ng_INCLUDE_DIR=${minizip-ng}/include/minizip-ng"
  ]
  ++ lib.optional (!pythonBindings) "-DOCIO_BUILD_PYTHON=OFF"
  ++ lib.optional (!buildApps) "-DOCIO_BUILD_APPS=OFF";

  # precision issues on non-x86
  doCheck = stdenv.hostPlatform.isx86_64;
  # Tends to fail otherwise.
  enableParallelChecking = false;

  meta = {
    homepage = "https://opencolorio.org";
    description = "Color management framework for visual effects and animation";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.rytone ];
    platforms = lib.platforms.unix;
  };
}
