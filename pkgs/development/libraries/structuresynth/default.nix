{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  wrapQtAppsHook,
  libGL,
  libGLU,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "structuresynth";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "alemuntoni";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-uFz4WPwA586B/5p+DUJ/W8KzbHLBhLIwP6mySZJ1vPY=";
  };

  outputs = [
    "dev"
    "out"
  ];

  buildInputs = [
    libGL
    libGLU
    qtbase
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn STATIC SHARED \
      --replace-warn '"'$'{CMAKE_CURRENT_LIST_DIR}"' \
      '$<BUILD_INTERFACE:''${CMAKE_CURRENT_LIST_DIR}> $<INSTALL_INTERFACE:''${CMAKE_INSTALL_INCLUDEDIR}>'
    echo "install(TARGETS structure-synth)" >> CMakeLists.txt
    echo 'install(FILES ''${HEADERS} TYPE INCLUDE)' >> CMakeLists.txt
  '';

  meta = with lib; {
    description = "Generate 3D structures by specifying a design grammar";
    homepage = "https://github.com/alemuntoni/StructureSynth";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nim65s ];
  };
})
