{
  buildDunePackage,
  alcotest,
  domainslib,
  raven,
  raven-nx-datasets,
  raven-rune,
  raven-saga,
  yojson,
}:

buildDunePackage {
  pname = "kaun";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    domainslib
    raven-nx-datasets
    raven-rune
    raven-saga
    yojson
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];

  # delete tests that require internet connection
  preCheck = ''
    rm -r kaun/test/{bert,gpt2}
  '';

  meta = raven.meta // {
    description = "Flax-inspired neural network library for OCaml";
    longDescription = ''
      Kaun brings modern deep learning to OCaml with a flexible,
      type-safe API for building and training neural networks.
      It leverages Rune for automatic differentiation and computation graph optimization
      while maintaining OCaml's functional programming advantages.
    '';
  };
}
