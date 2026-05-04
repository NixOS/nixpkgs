{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trinity";
  version = "1.9-unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "546f576fae24427c84007fd392c824815a459e38";
    hash = "sha256-J2h+g7TjXjfkIArbecdi1Y8ASJBK/UKE4C/tPlF6D3Q=";
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
