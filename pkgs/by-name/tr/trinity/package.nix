{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trinity";
  version = "1.9-unstable-2024-09-19";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "ba2360ed84a8c521d9c34af9c909315ea7c62aad";
    hash = "sha256-lj27EtMzj+ULrAJh27rjiuL3/SzW/NRMG65l8sBi8k4=";
  };

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts
  '';

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
