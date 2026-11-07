{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trinity";
  version = "1.9-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "3d8e000aaff39ff1a24aee68d3f2b4f70e971bc2";
    hash = "sha256-ZPFSWot6T7o2Hg+1KvAF0nYKC+5kW92m+j9h4Gp5kBs=";
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
