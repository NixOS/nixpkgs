{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trinity";
  version = "1.9-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "4ecfd4492750cc7a92e0ccba197a308c5456b564";
    hash = "sha256-4n44ZqA7T9SoQdUwXa4LJIDwyU91rV0lRMGiQqxTn1c=";
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
