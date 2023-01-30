{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, expat
, libyamlcpp
, ilmbase
, pystring
, imath
, minizip-ng
# Only required on Linux
, glew
, freeglut
# Only required on Darwin
, Carbon
, GLUT
, Cocoa
# Python bindings
, pythonBindings ? true # Python bindings
, python3Packages
# Build apps
, buildApps ? true # Utility applications
, lcms2
, openexr_3
}:

stdenv.mkDerivation rec {
  pname = "opencolorio";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenColorIO";
    rev = "v${version}";
    sha256 = "sha256-l5UUysHdP/gb4Mn5A64XEoHOkthl6Mlb95CuI0l4vXQ=";
  };

  patches = [
    (fetchpatch {
      name = "darwin-no-hidden-l.patch";
      url = "https://github.com/AcademySoftwareFoundation/OpenColorIO/commit/48bab7c643ed8d108524d718e5038d836f906682.patch";
      revert = true;
      sha256 = "sha256-0DF+lwi2nfkUFG0wYvL3HYbhZS6SqGtPWoOabrFS1Eo=";
    })
    (fetchpatch {
      name = "pkg-config-absolute-path.patch";
      url = "https://github.com/AcademySoftwareFoundation/OpenColorIO/commit/332462e7f5051b7e26ee3d8c22890cd5e71e7c30.patch";
      sha256 = "sha256-7xHALhnOkKszgFBgPIbiZQaORnEJ+1M6RyoZdFgjElM=";
    })
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # these tests don't like being run headless on darwin. no builtin
    # way of skipping tests so this is what we're reduced to.
    substituteInPlace tests/cpu/Config_tests.cpp \
      --replace 'OCIO_ADD_TEST(Config, virtual_display)' 'static void _skip_virtual_display()' \
      --replace 'OCIO_ADD_TEST(Config, virtual_display_with_active_displays)' 'static void _skip_virtual_display_with_active_displays()'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    expat
    libyamlcpp
    ilmbase
    pystring
    imath
    minizip-ng
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ glew freeglut ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Carbon GLUT Cocoa ]
    ++ lib.optionals pythonBindings [ python3Packages.python python3Packages.pybind11 ]
    ++ lib.optionals buildApps [
      lcms2
      openexr_3
    ];

  cmakeFlags = [
    "-DOCIO_INSTALL_EXT_PACKAGES=NONE"
    # GPU test fails with: freeglut (GPU tests): failed to open display ''
    "-DOCIO_BUILD_GPU_TESTS=OFF"
  ] ++ lib.optional (!pythonBindings) "-DOCIO_BUILD_PYTHON=OFF"
    ++ lib.optional (!buildApps) "-DOCIO_BUILD_APPS=OFF";

  # precision issues on non-x86
  doCheck = stdenv.isx86_64;

  meta = with lib; {
    homepage = "https://opencolorio.org";
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.rytone ];
    platforms = platforms.unix;
  };
}
