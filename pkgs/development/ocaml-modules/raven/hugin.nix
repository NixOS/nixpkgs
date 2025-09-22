{
  buildDunePackage,
  raven,
  raven-nx,
  alcotest,
  cairo2,
  dune-configurator,
  pkg-config,
  SDL2,
}:

buildDunePackage {
  pname = "hugin";

  inherit (raven) version src;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dune-configurator
    SDL2
  ];

  propagatedBuildInputs = [
    raven-nx
    cairo2
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = raven.meta // {
    description = "Visualization library for OCaml";
    longDescription = ''
      Hugin is a powerful visualization library for OCaml that produces publication-quality plots and charts.
      It integrates with the Raven ecosystem to provide visualization of Nx data.
    '';
  };
}
