{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, libfmvoice
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vgm2x";
  version = "0.0.0-unstable-2023-08-27";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "vgm2x";
    rev = "5128055ab2b356e173b53e2afd31202a59505a39";
    hash = "sha256-DwDcSUdfOsDlajYtzg5xM5P9QPOqLp8b0sEpE18kfzA=";
  };

  postPatch = ''
    rmdir libfmvoice
    cp --no-preserve=all -r ${libfmvoice.src} libfmvoice
  '';

  strictDeps = true;

  enableParallelBuilding = true;

  buildInputs = [
    zlib
  ];

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 vgm2opm $out/bin/vgm2opm

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "VGM file extraction tools";
    homepage = "https://github.com/vampirefrog/vgm2x";
    license = licenses.gpl3Only;
    mainProgram = "vgm2opm";
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
})
