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
, openimageio2
, openexr
}:

stdenv.mkDerivation rec {
  pname = "opencolorio";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenColorIO";
    rev = "v${version}";
    sha256 = "sha256-e1PpWjjfSjtgN9Rs/+lsA45Z9S4y4T6nqrJ02DZ4vjs=";
  };

  patches = [
    (fetchpatch {
      name = "darwin-no-hidden-l.patch";
      url = "https://github.com/AcademySoftwareFoundation/OpenColorIO/commit/48bab7c643ed8d108524d718e5038d836f906682.patch";
      revert = true;
      sha256 = "sha256-0DF+lwi2nfkUFG0wYvL3HYbhZS6SqGtPWoOabrFS1Eo=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    expat
    libyamlcpp
    ilmbase
    pystring
    imath
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ glew freeglut ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Carbon GLUT Cocoa ]
    ++ lib.optionals pythonBindings [ python3Packages.python python3Packages.pybind11 ]
    ++ lib.optionals buildApps [ lcms2 openimageio2 openexr ];

    cmakeFlags = [
      "-DOCIO_INSTALL_EXT_PACKAGES=NONE"
    ] ++ lib.optional (!pythonBindings) "-DOCIO_BUILD_PYTHON=OFF"
      ++ lib.optional (!buildApps) "-DOCIO_BUILD_APPS=OFF";

  # TODO Investigate this: Python and GPU tests fail to load libOpenColorIO.so.2.0
  # doCheck = true;

  meta = with lib; {
    homepage = "https://opencolorio.org";
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.rytone ];
    platforms = platforms.unix;
  };
}
