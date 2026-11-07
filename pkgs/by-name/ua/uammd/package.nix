{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uammd";
  version = "3.1.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RaulPPelaez";
    repo = "UAMMD";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ua85pcT9kpaZYp3IDO6aGwcigRYTxgzMDWClczCcclY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++14+ header-only fast generic multiscale CUDA Molecular Dynamics framework";
    homepage = "https://github.com/RaulPPelaez/UAMMD";
    changelog = "https://github.com/RaulPPelaez/UAMMD/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
