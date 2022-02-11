import ./generic.nix {
  majorVersion = "7.1";
  minorVersion = "1";
  sourceSha256 = "0nm7xwwj7rnsxjdv2ssviys8nhci4n9iiiqm2y14s520hl2dsp1d";
  patchesToFetch = [
    {
      url = "https://gitlab.kitware.com/vtk/vtk/-/commit/706f1b397df09a27ab8981ab9464547028d0c322.diff";
      sha256 = "1q3pi5h40g05pzpbqp75xlgzvbfvyw8raza51svmi7d8dlslqybx";
    }

    {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/vtk/files/vtk-8.2.0-gcc-10.patch?id=c4256f68d3589570443075eccbbafacf661f785f";
      sha256 = "sha256:0bpwrdfmi15grsg4jy7bzj2z6511a0c160cmw5lsi65aabyh7cl5";
    }

    # Add missing include required with recent Qt.
    {
      url = "https://gitlab.kitware.com/vtk/vtk/-/commit/797f28697d5ba50c1fa2bc5596af626a3c277826.diff";
      sha256 = "BFjoKws1hVD3Ly9RS4lGN62J6RTyI1E8ATHrZdzg7ds=";
    }
  ];
}
