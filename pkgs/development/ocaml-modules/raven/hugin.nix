{
  buildDunePackage,
  SDL2,
  alcotest,
  base64,
  cairo2,
  dune-configurator,
  pkg-config,
  raven,
  raven-nx,
}:

buildDunePackage {
  pname = "hugin";

  inherit (raven) version src postUnpack;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dune-configurator
    SDL2
  ];

  propagatedBuildInputs = [
    base64
    cairo2
    raven-nx
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
