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

buildDunePackage rec {
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

  doCheck = false;
  # Tests fail with Clang: https://github.com/owlbarn/owl/issues/462
  # and with GCC 13: https://github.com/owlbarn/owl/issues/653
}
