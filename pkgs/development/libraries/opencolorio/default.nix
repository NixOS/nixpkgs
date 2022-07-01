{
  stdenv, lib, fetchFromGitHub,
  cmake, expat, libyamlcpp, ilmbase, pystring, # Base dependencies

  glew, freeglut, # Only required on Linux
  Carbon, GLUT, Cocoa, # Only required on Darwin

  pythonBindings ? true, # Python bindings
  python3Packages,

  buildApps ? true, # Utility applications
  lcms2, openimageio2, openexr,
}:

with lib;

stdenv.mkDerivation rec {
  pname = "opencolorio";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenColorIO";
    rev = "v${version}";
    sha256 = "sha256-Yr7yypXxf3ZvQVsDxVuKTN/DGPaLkIWli26RRoEDMdA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ expat libyamlcpp ilmbase pystring ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ glew freeglut ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Carbon GLUT Cocoa ]
    ++ lib.optionals pythonBindings [ python3Packages.python python3Packages.pybind11 ]
    ++ lib.optionals buildApps [ lcms2 openimageio2 openexr ];

    cmakeFlags = [ "-DOCIO_INSTALL_EXT_PACKAGES=NONE" ]
    ++ lib.optional (!pythonBindings) "-DOCIO_BUILD_PYTHON=OFF"
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
