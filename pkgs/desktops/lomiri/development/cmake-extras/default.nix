{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  cmake,
  qtbase,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cmake-extras";
  version = "1.8";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/cmake-extras";
    tag = finalAttrs.version;
    hash = "sha256-4KPk8GrpmrrwN6epmzGVh0fCBgP765xR3Im5mMmE9vw=";
  };

  postPatch = ''
    # We have nothing to build here, no need to depend on a C compiler
    substituteInPlace CMakeLists.txt \
      --replace-fail 'project(cmake-extras' 'project(cmake-extras LANGUAGES NONE'

    # This is in a function that reverse dependencies use to determine where to install their files to
    substituteInPlace src/QmlPlugins/QmlPluginsConfig.cmake \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
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

  meta = {
    description = "Collection of add-ons for the CMake build tool";
    homepage = "https://gitlab.com/ubports/development/core/cmake-extras";
    changelog = "https://gitlab.com/ubports/development/core/cmake-extras/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.all;
  };
})
