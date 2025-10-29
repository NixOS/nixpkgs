{
  buildDunePackage,
  dune-configurator,
  alcotest,
  ctypes,
  stdio,
  openblasCompat,
  owl-base,
  npy,
}:

buildDunePackage {
  pname = "owl";

  inherit (owl-base) version src meta;

  checkInputs = [ alcotest ];
  buildInputs = [
    dune-configurator
    stdio
  ];
  propagatedBuildInputs = [
    ctypes
    openblasCompat
    owl-base
    npy
  ];

  doCheck = true;
}
