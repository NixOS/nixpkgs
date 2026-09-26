{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  pkg-config,
  zlib,
  libvgm,
  inih,
}:

stdenv.mkDerivation {
  pname = "vgmplay-libvgm";
  version = "0.52.0-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "vgmplay-libvgm";
    rev = "14e1b4edf53a66ee5d9fdb0c584d6d564cd27ac4";
    hash = "sha256-Qy4G3uCC3p/VmolTzl7b5p9HLw2QXvl51jAJMIElBXQ=";
  };

  # We don't want text files in bindir
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'install(FILES "''${SRC}" RENAME "''${DST}" DESTINATION "''${CMAKE_INSTALL_BINDIR}")' \
        'install(FILES "''${SRC}" RENAME "''${DST}" DESTINATION "''${CMAKE_INSTALL_DATADIR}/vgmplay")'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    zlib
    libvgm
    inih
  ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/ValleyBell/vgmplay-libvgm.git";
  };

  meta = {
    mainProgram = "vgmplay";
    homepage = "https://github.com/ValleyBell/vgmplay-libvgm";
    description = "New VGMPlay, based on libvgm";
    license = lib.licenses.unfree; # no licensing text anywhere yet
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
}
