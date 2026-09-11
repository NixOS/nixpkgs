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
  version = "0.52.0-unstable-2026-08-24";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "vgmplay-libvgm";
    rev = "4208caf6b48a323db660f23f920c09dd4fff8957";
    hash = "sha256-0imOV2Yb16V/BOM+Ajj3q8S3Lun3V7MRU1dREbEOEnY=";
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
