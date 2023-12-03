{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, libfmvoice
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vgm2x";
  version = "0.0.0-unstable-2023-05-10";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "vgm2x";
    rev = "c46c63c84d79aaa274f5259b5d7967181282cc0b";
    hash = "sha256-Y5O82Y1882Dokz6tuEPqbkKvzoZbUiJlj6lFK9GCUuY=";
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
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
})
