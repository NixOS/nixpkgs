{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trinity";
  version = "1.9-unstable-2026-11-11";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "20d79b6d8e1531a40d164642125fa364904fa4ae";
    hash = "sha256-/myfP9dfHkDhqbVdeIbid8L8z4U/+f0VufMGOv5rRRU=";
  };

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts
  '';

  # https://salsa.debian.org/debian/trinity/-/merge_requests/2
  env.NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" ];

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "Linux System call fuzz tester";
    mainProgram = "trinity";
    homepage = "https://github.com/kernelslacker/trinity";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
