{
  lib,
  stdenv,
  fetchFromGitHub,
  mpi,
  mpich,
  tmux,
  reptyr,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "tmpi";
  version = "0-unstable-2022-02-22";

  src = fetchFromGitHub {
    owner = "Azrael3000";
    repo = "tmpi";
    rev = "f5a0fd8848b5c87b301edc8a23de9bfcfbd41918";
    hash = "sha256-BaOaMpsF8ho8EIVuHfu4+CiVV3yLoC3tDkLq4R8BYBA=";
  };

  propagatedBuildInputs = [
    mpi
    mpich
    reptyr
    tmux
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    install -m755 tmpi $out/bin/tmpi

    wrapProgram $out/bin/tmpi \
      --prefix PATH : ${
        lib.makeBinPath [
          mpi
          mpich
          tmux
          reptyr
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Run a parallel command inside a split tmux window";
    mainProgram = "tmpi";
    homepage = "https://github.com/Azrael3000/tmpi";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ vasissualiyp ];
    platforms = reptyr.meta.platforms;
  };
}
