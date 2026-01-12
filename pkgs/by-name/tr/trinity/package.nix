{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trinity";
  version = "1.9-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "294c46522620afffd7b57af7ef743131ff55a488";
    hash = "sha256-Fm9bwJ/ofDgSbe/YUgl22Rf0F+NCV32xLPA2kw36zFs=";
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
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.linux;
  };
})
