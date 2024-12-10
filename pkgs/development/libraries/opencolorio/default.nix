{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  expat,
  yaml-cpp,
  pystring,
  imath,
  minizip-ng,
  # Only required on Linux
  glew,
  freeglut,
  # Only required on Darwin
  Carbon,
  GLUT,
  Cocoa,
  # Python bindings
  pythonBindings ? true, # Python bindings
  python3Packages,
  # Build apps
  buildApps ? true, # Utility applications
  lcms2,
  openexr_3,
}:

stdenv.mkDerivation rec {
  pname = "opencolorio";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenColorIO";
    rev = "v${version}";
    sha256 = "sha256-E4TmMEFzI3nKqiDFaAkNx44uo84sacvZqjbfWe3A8fE=";
  };

  patches = [
    (fetchpatch {
      # Taken from https://github.com/AcademySoftwareFoundation/OpenColorIO/pull/1891.
      name = "opencolorio-yaml-cpp-8.0-compat.patch";
      url = "https://github.com/AcademySoftwareFoundation/OpenColorIO/commit/e99b4afcf0408d8ec56fdf2b9380327c9284db00.patch";
      sha256 = "sha256-7eIvVWKcpE0lmuYdNqFQFHkW/sSSzQ//LNIMOC28KZg=";
    })
    # Workaround for https://gitlab.kitware.com/cmake/cmake/-/issues/25200.
    # Needed for zlib >= 1.3 && cmake < 3.27.4.
    ./broken-cmake-zlib-version.patch
    # Fix incorrect line number in test
    ./line-numbers.patch
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # these tests don't like being run headless on darwin. no builtin
    # way of skipping tests so this is what we're reduced to.
    substituteInPlace tests/cpu/Config_tests.cpp \
      --replace 'OCIO_ADD_TEST(Config, virtual_display)' 'static void _skip_virtual_display()' \
      --replace 'OCIO_ADD_TEST(Config, virtual_display_with_active_displays)' 'static void _skip_virtual_display_with_active_displays()'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [
      expat
      yaml-cpp
      pystring
      imath
      minizip-ng
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glew
      freeglut
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Carbon
      GLUT
      Cocoa
    ]
    ++ lib.optionals pythonBindings [
      python3Packages.python
      python3Packages.pybind11
    ]
    ++ lib.optionals buildApps [
      lcms2
      openexr_3
    ];

  cmakeFlags =
    [
      "-DOCIO_INSTALL_EXT_PACKAGES=NONE"
      "-DOCIO_USE_SSE2NEON=OFF"
      # GPU test fails with: freeglut (GPU tests): failed to open display ''
      "-DOCIO_BUILD_GPU_TESTS=OFF"
      "-Dminizip-ng_INCLUDE_DIR=${minizip-ng}/include/minizip-ng"
    ]
    ++ lib.optional (!pythonBindings) "-DOCIO_BUILD_PYTHON=OFF"
    ++ lib.optional (!buildApps) "-DOCIO_BUILD_APPS=OFF";

  # precision issues on non-x86
  doCheck = stdenv.isx86_64;
  # Tends to fail otherwise.
  enableParallelChecking = false;

  meta = with lib; {
    homepage = "https://opencolorio.org";
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.rytone ];
    platforms = platforms.unix;
  };
}
