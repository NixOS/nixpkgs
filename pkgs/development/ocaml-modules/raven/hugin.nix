{
  buildDunePackage,
  SDL2,
  cairo,
  dune-configurator,
  pkg-config,
  raven,
  raven-nx,
  windtrap,
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
    cairo
    raven-nx
  ];

  doCheck = true;

  checkInputs = [
    windtrap
  ];

  meta = raven.meta // {
    description = "Visualization library for OCaml";
    longDescription = ''
      Hugin is a powerful visualization library for OCaml that produces publication-quality plots and charts.
      It integrates with the Raven ecosystem to provide visualization of Nx data.
    '';
  };
}
