{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  cmake,
  qtbase,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cmake-extras";
  version = "1.7";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/cmake-extras";
    rev = finalAttrs.version;
    hash = "sha256-5bLMk21pSZkuU3jAGTnjPc9ZrvVZqMUWSfFgkTtkYLw=";
  };

  postPatch = ''
    # We have nothing to build here, no need to depend on a C compiler
    substituteInPlace CMakeLists.txt \
      --replace 'project(cmake-extras' 'project(cmake-extras LANGUAGES NONE'

    # This is in a function that reverse dependencies use to determine where to install their files to
    substituteInPlace src/QmlPlugins/QmlPluginsConfig.cmake \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  '';

  strictDeps = true;

  # Produces no binaries
  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qtbase
  ];

  meta = with lib; {
    description = "A collection of add-ons for the CMake build tool";
    homepage = "https://gitlab.com/ubports/development/core/cmake-extras/";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.all;
  };
})
