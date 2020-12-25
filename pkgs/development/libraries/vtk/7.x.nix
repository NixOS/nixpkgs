import ./generic.nix {
  majorVersion = "7.1";
  minorVersion = "1";
  sourceSha256 = "0nm7xwwj7rnsxjdv2ssviys8nhci4n9iiiqm2y14s520hl2dsp1d";
  patchesToFetch = [{
   url = "https://gitlab.kitware.com/vtk/vtk/-/commit/706f1b397df09a27ab8981ab9464547028d0c322.diff";
   sha256 = "1q3pi5h40g05pzpbqp75xlgzvbfvyw8raza51svmi7d8dlslqybx";
 }];
}
